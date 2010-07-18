gem 'rack', ">= 1.1.0"
require 'rack'
module DbAgile
  #
  # Implements a Restful rack middleware on top of dbagile
  #
  class Restful
    
    # Creates a Restful handler
    def initialize(environment, &block)
      @dba = DbAgile::Command::API.new(environment)
      block.call(@dba) if block
    end
    
    # Rack handler
    def call(env)
      method = env['REQUEST_METHOD'].downcase.to_sym
      if self.respond_to?(method)
        result = self.send(method, env)
      else
        [
          500, 
          {'Content-Type' => 'text/plain'},
          ["Unsupported restful method #{env['REQUEST_METHOD']}"]
        ]
      end
    rescue Exception => ex
      [500, {'Content-Type' => 'text/plain'}, [ex.message]]
    end
    
  end # class Restful
end # module DbAfile
