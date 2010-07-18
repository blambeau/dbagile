module DbAgile
  class Restful
    module Utils
      
      # Which content type for which format
      FORMAT_TO_CONTENT_TYPE = {
        :csv  => "text/csv",
        :text => "text/plain",
        :json => "application/json",
        :yaml => "text/yaml",
        :xml  => "text/xml",
        :ruby => "text/plain"
      }
      
      # Checks if a format is known. Returns the associated content type.
      def known_format?(f)
        FORMAT_TO_CONTENT_TYPE[f]
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
      def _404_(env)
        [
          404, 
          {'Content-Type' => 'text/plain'},
          ["Not found #{env['PATH_INFO']}"]
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

    end # module Utils
  end # class Restful
end # module DbAgile