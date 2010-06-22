module Facts
  module Restful
    class Server
      module Utils
        
        # Returns json HTTP headers
        def json_header
          {'Content-Type' => 'application/json'}
        end
      
        # Encodes a result as json
        def json_result(status, heading, res)
          [status, heading.merge(json_header), [ Restful::json_encode(res || {}) ]]
        end

        #
        # Decodes a path and returns a [fact_name, projection] pair.
        #
        def decode_path(path)
          parts = path.split('/').delete_if{|s| s.empty? or s.nil?}
          case parts.size
            when 0
              [:system, {:version => Facts::VERSION}]
            when 1
              [parts[0].to_sym, {}]
            when 2
              value = parts[1]
              value = value.to_i if value =~ /^\d+$/
              [parts[0].to_sym, {:'#' => value}]
            else
              raise UnexpectedPathError, "Unexpected path #{path}"
          end
        end
        
        # 
        # Decodes a Rack environment and returns a triple [access_kind, 
        # fact_name, fact_projection]
        #
        def decode(env)
          name, projection = decode_path(env['PATH_INFO'])
          kind = projection.empty? ? :relation : :tuple
          [kind, name, projection]
        end
        
      end # module Utils
    end # class Server
  end # module Restful
end # module Facts