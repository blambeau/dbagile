module DbAgile
  module Restful
    class Client
      module Delete

        # Makes a delete request
        def delete(path, projection = nil)
          with_uri(path, projection) do |uri|
            Net::HTTP.start(uri.host, uri.port) {|http|
              req = Net::HTTP::Delete.new(uri.path)
              req.set_form_data(projection) unless projection.nil?
              res = http.request(req)
              yield(res, http)
              res.body
            }
          end
        end
  
      end # module Delete
    end # class Client
  end # module Restful
end # module DbAgile
