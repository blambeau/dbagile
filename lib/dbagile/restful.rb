require 'stringio'
require 'dbagile'
require 'dbagile/restful/utils'
require 'dbagile/restful/get'
require 'dbagile/restful/post'
module DbAgile
  #
  # Implements a Restful rack middleware on top of dbagile
  #
  class Restful
    include DbAgile::Environment::Delegator
    include DbAgile::Restful::Utils
    include Restful::Get
#    include Restful::Post
    
    # Environment
    attr_reader :environment
    
    # Creates a Restful handler
    def initialize(environment = DbAgile::default_environment, &block)
      raise "Environment may not be nil" if environment.nil?
      block.call(environment) if block
      @environment = environment
    end
    
    # Rack handler
    def call(env)
      method = env['REQUEST_METHOD'].downcase.to_sym
      if self.respond_to?(method)
        result = self.send(method, env)
      else
        puts "Unsupported restful method #{env['REQUEST_METHOD']}"
        [
          500, 
          {'Content-Type' => 'text/plain'},
          ["Unsupported restful method #{env['REQUEST_METHOD']}"]
        ]
      end
    rescue Exception => ex
      puts ex.message
      puts ex.backtrace.join("\n")
      [500, {'Content-Type' => 'text/plain'}, [ex.message]]
    end
    
  end # class Restful
end # module DbAfile
