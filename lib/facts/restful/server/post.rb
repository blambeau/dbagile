module Facts
  module Restful
    class Server
      module Post
        
        # Implements POST access of the restful interface
        def post(env)
          kind, name, projection = decode(env)
          request = ::Rack::Request.new(env)
          if request.content_type == 'application/json'
            projection.merge!(Restful::json_decode(request.body.readlines.join))
            fact = db.fact!(name, projection)
            [200, {}, fact]
          else
            raise UnexpectedProtocolError, request.content_type
          end
        end
        
      end # module Post
    end # class Server
  end # module Restful
end # module Facts