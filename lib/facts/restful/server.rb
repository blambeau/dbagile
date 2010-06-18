module Facts
  module Restful
    class Server
      
      # Creates a servlet instance
      def initialize(uri)
        @uri = uri
      end
      
      # Returns the facts database
      def db
        @db ||= Facts::connect(uri)
      end
      
      # Rack handler
      def call(env)
        case env['REQUEST_METHOD']
          when "GET"
            do_get(env)
          when "POST"
            do_post(env)
          when "PUT"
            do_put(env)
          when "DELETE"
            do_delete(env)
        end
        [200, {}, ["hello"]]
      end
      
      def do_get(env)
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