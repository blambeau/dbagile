module DbAgile
  module Restful
    class Middleware
      module Post
      
        # Implements POST access of the restful interface
        def post(env)
          request = Rack::Request.new(env)
          decode(env) do |connection, table, format|
            format = :json if format.nil?
            heading = connection.heading(table)
            tuple = params_to_tuple(request.POST, heading)
            inserted = connection.transaction do |t|
              t.insert(table, tuple)
            end
            [format, to_xxx_enumerable(format, [ inserted ], tuple.keys)]
          end
        end
      
      end # module Get
    end # class Middleware
  end # module Restful
end # module Facts