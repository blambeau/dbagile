module DbAgile
  module Restful
    class Middleware
      module Utils
        include ::DbAgile::IO
      
        # Converts get parameters to a tuple for projection
        def params_to_tuple(params, heading)
          copy = {}
          params.each_pair{|k, v| 
            k = k.to_sym
            next unless heading.key?(k)
            copy[k] = SByC::TypeSystem::Ruby::coerce(v, heading[k])
          }
          copy
        end
      
        # Returns a copyright response
        def _copyright_(env)
          [
            200, 
            {'Content-Type' => 'text/plain'}, 
            [ "dba #{DbAgile::VERSION} (c) 2010, Bernard Lambeau" ]
          ]
        end
      
        # Returns a 404 response
        def _404_(env, ex = nil)
          [
            404, 
            {'Content-Type' => 'text/plain'},
            [ "Not found #{env['PATH_INFO']}: " ] + (ex.nil? ? [] : [ ex.message ])
          ]
        end
      
        # Returns a 200 response for a given format
        def _200_(env, type, result)
          [
            200,
            {'Content-Type' => type},
            result
          ]
        end
      
        # Converts a dataset-like object to an enumerable rack result
        def to_xxx_enumerable(format, dataset, columns)
          buffer = StringIO.new
          method = "to_#{format}".to_sym
          DbAgile::IO.send(method, dataset, columns, buffer)
          [ buffer.string ]
        end

      end # module Utils
    end # class Middleware
  end # module Restful
end # module DbAgile