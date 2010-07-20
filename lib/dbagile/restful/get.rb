module DbAgile
  class Restful
    module Get
      
      # Implements GET access of the restful interface
      def get(env)
        request = Rack::Request.new(env)
        decode(env, :json) do |connection, table, format|
        
          # Compute the projection on query string
          heading = connection.heading(table)
          projection = params_to_tuple(request.GET, heading)
        
          # Retrieve dataset
          columns = connection.column_names(table)
          dataset = connection.dataset(table, projection)

          # Make output now
          to_xxx_enumerable(format, dataset, columns)
        end
      end
      
    end # module Get
  end # class Restful
end # module Facts