module Facts
  module Restful
    class Server
      
      ### Class methods ############################################################
      
      # Starts a server instance 
      def self.start(dburi, options = Restful::DEFAULT_RACK_OPTIONS)
        rack_server  = Rack::Handler.default
        rack_app     = Rack::Builder.new{ run Facts::Restful::Server.new(dburi) }
        thread       = Thread.new(rack_server, rack_app, options.dup){|s,a,o| s.run(a, o) }
        
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
        @db ||= Facts::connect(@uri)
      end
      
      # Decodes a request
      def decode(req)
        method = req.request_method.downcase.to_sym
        path, params = req.path, Restful::hash_methodize(req.params)
        if req.path.strip == '/'
          [:get, :system, {:version => ::Facts::VERSION}]
        elsif /([a-z]+)/ =~ path
          [method, $1.to_sym, params]
        else 
          nil
        end
      end
      
      # Rack handler
      def call(env)
        method, path, params = decode(Rack::Request.new(env))
        if method
          self.send(method, path, params)
        else
          [404, {}, ["404 not found"]]  
        end
      rescue Exception => ex
        [500, {}, [ex.message] + ex.backtrace]
      end
      
      # Returns json HTTP headers
      def json_header
        {'Content-Type' => 'application/json'}
      end
      
      # Encodes a result as json
      def json_result(status, res)
        [status, json_header, Restful::json_encode(res)]
      end
      
      def get(name, params)
        fact = db.fact(name, params, nil, 404)
        case fact
          when 404
            json_result(404, {:message => "No such fact"})
          else
            json_result(200, fact)
        end
      end
      
      def post(name, params)
        json_result(200, db.fact!(name, params))
      end
      alias :put :post
      
      def delete(name, params)
        json_result(200, db.nofact!(name, params))
      end
      
    end # class Server
  end # module Restful
end # module Facts