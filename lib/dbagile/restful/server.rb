if RUBY_VERSION == "1.8.6"
  gem 'rack', "= 1.1.0"
  require 'rack'
else
  gem 'rack', ">= 1.1.0"
  require 'rack'
end
require 'dbagile/restful/middleware'
require 'uri'
require "net/http"
require 'webrick'
module DbAgile
  module Restful
    class Server
      
      # Default Rack options for restful server and client
      DEFAULT_RACK_OPTIONS = {:Port => 8711, :Host => "127.0.0.1", :AccessLog => []}
      
      # Server options
      attr_reader :options
    
      # Creates a server instance
      def initialize(environment, options = DEFAULT_RACK_OPTIONS)
        raise "Environment may not be nil" if environment.nil?
        @environment = environment
        @options = options
      end
    
      # Returns the server uri given by options
      def uri
        URI::parse("http://#{options[:Host]}:#{options[:Port]}/")
      end
    
      # Starts the server inside a thread
      def start
        myself, env  = self, @environment
        rack_server  = ::Rack::Handler::default
        rack_app     = ::Rack::Builder.new{ run DbAgile::Restful::Middleware.new(env) }
        thread       = Thread.new(rack_server, rack_app, options.dup){|s,a,o| 
          s.run(a, o){|server| @server = server}
        }
        
        # Wait until the server is loaded
        try, ok, res = 0, false, nil
        begin
          res = Net::HTTP.get(uri)
          ok = true
        rescue Errno::ECONNREFUSED => ex
          sleep 0.3
        end until (ok or (try += 1)>10)
        raise "Unable to connect to server" if try >= 10
        
        @environment.say("Have a look at #{uri}")
        thread
      end
      
      # Stops the server
      def stop
        @server.shutdown if @server.respond_to?(:shutdown)
        @server = nil
      end
      
    end # class Server
  end # module Restful
end # module DbAgile