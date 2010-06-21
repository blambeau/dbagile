module Facts
  module Restful
    class Server
      
      ### Class methods ############################################################
      
      # Starts a server instance 
      def self.start(dburi, options = Restful::DEFAULT_RACK_OPTIONS)
        rack_server  = Rack::Handler.default
        rack_app     = Rack::Builder.new{ run Facts::Restful::Server.new(dburi) }
        thread       = Thread.new(rack_server, rack_app, options){|s,a,o| s.run(a, o) }
        
        # Wait until the server is loaded
        try, ok, res = 0, false, nil
        begin
          res = Net::HTTP.get(Restful::server_uri(options))
          ok = true
        rescue Errno::ECONNREFUSED => ex
          sleep 0.3
        end until (ok or (try += 1)>10)
        raise "Unable to connect to server" if try >= 10

        thread
      end

      ### Instance methods #########################################################
      
      # Creates a server instance
      def initialize(uri)
        @uri = uri
      end
      
      # Returns the facts database
      def db
        @db ||= Facts::connect(uri)
      end
      
      # Methodizes keys of a hash
      def hash_methodize(hash)
        m = {}
        hash.each_pair{|k,v| m[k.to_s.to_sym] = v}
        m
      end
      
      # Rack handler
      def call(env)
        req = Rack::Request.new(env)
        method, path, params = req.request_method, req.path, hash_methodize(req.params)
        case method
          when "GET"
            do_get(path, params)
          when "POST"
            do_post(env)
          when "PUT"
            do_put(env)
          when "DELETE"
            do_delete(env)
        end
        [200, {}, ["hello"]]
      end
      
      def do_get(path, params)
        puts "GET: #{path} :: #{params.inspect}"
      end
      
      def do_post(env)
      end
      
      def do_put(env)
      end
      
      def do_delete(env)
      end
      
    end # class Server
  end # module Restful
end # module Facts