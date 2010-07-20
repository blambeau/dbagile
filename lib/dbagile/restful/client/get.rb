module DbAgile
  module Restful
    class Client
      module Get

        # Makes a get request
        def get(path, projection = nil)
          with_uri(path, projection) do |uri|
            Net::HTTP.start(uri.host, uri.port) {|http|
              res = if uri.query
                http.get(uri.path + "?" + uri.query)
              else
                http.get(uri.path)
              end
              yield(res, http)
              res.body
            }
          end
        end
        
      end # module Get
    end # class Client
  end # module Restful
end # module DbAgile
