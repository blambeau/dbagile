module DbAgile
  module Restful
    class Middleware
      module Post
      
        # Implements POST access of the restful interface
        def post(env)
          request = Rack::Request.new(env)
          decode(env) do |connection, table, format|
            format = :json if format.nil?
            
            # Retrieve heading and keys
            heading = connection.heading(table)
            keys = connection.keys(table)
            
            # Tuple to insert/update
            tuple = params_to_tuple(request.POST, heading)
            inserted = connection.transaction do |t|
              if tuple_has_key?(tuple, keys)
                key_projected = tuple_key(tuple, keys)
                if connection.exists?(table, key_projected)
                  t.update(table, tuple, key_projected)
                else
                  t.insert(table, tuple)
                end
              else
                t.insert(table, tuple)
              end
            end
            
            [format, to_xxx_enumerable(format, [ inserted ], tuple.keys)]
          end
        end
      
      end # module Get
    end # class Middleware
  end # module Restful
end # module Facts