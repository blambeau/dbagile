module DbAgile
  class Restful
    module Post
      
      # Implements GET access of the restful interface
      def post(env)
        request = Rack::Request.new(env)
        decode(env, :json) do |connection, table, format|
          heading = connection.heading(table)
          tuple = params_to_tuple(request.POST, heading)
          # connection.transaction do |t|
          #   t.insert(table, tuple)
          # end
          to_xxx_enumerable(format, [ tuple ], tuple.keys)
        end
      end
      
    end # module Get
  end # class Restful
end # module Facts