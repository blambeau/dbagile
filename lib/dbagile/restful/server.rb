if RUBY_VERSION == "1.8.6"
  gem 'rack', "= 1.1.0"
  require 'rack'
else
  gem 'rack', ">= 1.1.0"
  require 'rack'
end
require 'uri'
require "net/http"
require 'webrick'
module DbAgile
  class Restful
    class Server
      
      # Default Rack options for restful server and client
      DEFAULT_RACK_OPTIONS = {:Port => 8711, :Host => "127.0.0.1", :AccessLog => []}
    
      # Creates a server instance
      def initialize(environment)
        raise "Environment may not be nil" if environment.nil?
        @environment = environment
      end
    
      # Returns the server uri given by options
      def server_uri(options = DEFAULT_RACK_OPTIONS)
        URI::parse("http://#{options[:Host]}:#{options[:Port]}/")
      end
    
      # Starts the server inside a thread
      def start(options = DEFAULT_RACK_OPTIONS)
        myself, env  = self, @environment
        rack_server  = ::Rack::Handler::default
        rack_app     = ::Rack::Builder.new{ run DbAgile::Restful.new(env) }
        thread       = Thread.new(rack_server, rack_app, options.dup){|s,a,o| 
          s.run(a, o){|server| @server = server}
        }
        
        # Wait until the server is loaded
        try, ok, res = 0, false, nil
        begin
          res = Net::HTTP.get(server_uri(options))
          ok = true
        rescue Errno::ECONNREFUSED => ex
          sleep 0.3
        end until (ok or (try += 1)>10)
        raise "Unable to connect to server" if try >= 10
        
        @environment.say("Have a look at #{server_uri(options)}")
        thread
      end
      
      # Stops the server
      def stop
        @server.shutdown if @server.respond_to?(:shutdown)
        @server = nil
      end
      
    end # class Server
  end # class Restful
end # module DbAgile