require 'facts/restful/server/utils'
require 'facts/restful/server/get'
require 'facts/restful/server/post'
module Facts
  module Restful
    class Server
      include Utils
      include Get
      include Post
      
      ### Class methods ############################################################
      
      # Starts a server instance 
      def self.start(dburi, options = Restful::DEFAULT_RACK_OPTIONS)
        Server.new(dburi).start
      end

      # Starts the server inside a thread
      def start(options = Restful::DEFAULT_RACK_OPTIONS)
        myself       = self
        rack_server  = Rack::Handler.default
        rack_app     = Rack::Builder.new{ run myself }
        thread       = Thread.new(rack_server, rack_app, options.dup){|s,a,o| 
          s.run(a, o){|server| @server = server}
        }
        
        # Wait until the server is loaded
        try, ok, res = 0, false, nil
        begin
          res = Net::HTTP.get(Restful::server_uri(options))
          ok = true
        rescue Errno::ECONNREFUSED => ex
          sleep 0.3
        end until (ok or (try += 1)>10)
        raise "Unable to connect to server" if try >= 10
      end
      
      # Stops the server
      def stop
        @server.shutdown if @server.respond_to?(:shutdown)
        @server = nil
      end
      
      ### Instance methods #########################################################
      
      # Creates a server instance
      def initialize(uri)
        @uri = uri
      end
      
      # Returns the facts database
      def db
        @db ||= Facts::connect(@uri)
      end
      
      # Rack handler
      def call(env)
        result = self.send(env['REQUEST_METHOD'].downcase.to_sym, env)
        res = json_result(*result)
        raise "Third in Rack response should respond to :each;\n#{res.inspect}" unless res[2].respond_to?(:each)
        res
      rescue Exception => ex
        puts ex.message
        puts ex.backtrace.join("\n")
        [500, {}, [ex.message] + ex.backtrace]
      end
      
    end # class Server
  end # module Restful
end # module Facts