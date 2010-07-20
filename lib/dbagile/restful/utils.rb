module DbAgile
  class Restful
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
          [ "Not found #{env['PATH_INFO']}" ] + (ex.nil? ? [] : [ ex.message ])
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
      
      # Decodes a path and yield the block with a connection and the 
      # requested format
      def decode(env, default_format = nil)
        case env['PATH_INFO'].strip[1..-1]
          when ''
            _copyright_(env)
          when /(\w+)\/(\w+)(\.(\w+))?$/
            db, table = $1.to_sym, $2.to_sym
            
            # Handle format
            if $3
              format = known_extension?($3)
              return _404_(env) unless format
            else
              format = default_format
            end
            
            result = with_connection(db) do |connection|
              yield(connection, table, format) 
            end
            content_type = DbAgile::IO::FORMAT_TO_CONTENT_TYPE[format]
            [200, {'Content-Type' => content_type}, result]
          else
            _404_(env)
        end
      rescue DbAgile::InvalidConfigurationName,
             DbAgile::NoSuchConfigError,
             DbAgile::NoSuchTableError => ex
        return _404_(env, ex.message)
      rescue DbAgile::Error, Sequel::Error => ex
        if ex.message =~ /exist/
          _404_(env)
        else
          raise
        end
      end

    end # module Utils
  end # class Restful
end # module DbAgile