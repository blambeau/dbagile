module DbAgile
  module Restful
    class Middleware
      module Delete
      
        # Implements DELETE access of the restful interface
        def delete(env)
          request = Rack::Request.new(env)
          decode(env) do |connection, table, format|
            heading = connection.heading(table)
            tuple = params_to_tuple(request.POST, heading)
            connection.transaction do |t|
              t.delete(table, tuple)
            end
            [ :json, [ JSON::generate(:ok => true) ] ]
          end
        end
      
      end # module Delete
    end # class Middleware
  end # module Restful
end # module Facts