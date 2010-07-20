module DbAgile
  module Restful
    class Client
      module Utils

        # Yields the block with an URI to access the server
        def with_uri(path, projection = nil)
          uri = "#{server_uri}#{path}"
          uri += ("?" + tuple_to_querystring(projection)) if projection
          yield(URI.parse(uri))
        end
        
      end # module Get
    end # module Utils
  end # module Restful
end # module DbAgile
