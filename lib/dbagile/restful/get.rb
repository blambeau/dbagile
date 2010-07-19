module DbAgile
  class Restful
    module Get
      
      # Makes a table export
      def _export_table(env, request, db, table, format)
        buffer = StringIO.new
        content_type = known_format?(format)
        with_connection(db) do |connection|
          projection = get_to_tuple(request.GET, connection.heading(table))
          method = "to_#{format}".to_sym
          connection.dataset(table, projection).send(method, buffer)
        end
        _200_(env, content_type, [ buffer.string ])
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
      
      # Implements GET access of the restful interface
      def get(env)
        request = Rack::Request.new(env)
        case request.path.strip[1..-1]
          when ''
            return _copyright_(env)
          when /(\w+)\/(\w+)\.(\w+)$/
            if format = known_extension?($3)
              return _export_table(env, request, $1.to_sym, $2.to_sym, format)
            end
        end
        return _404_(env)
      end
      
    end # module Get
  end # class Restful
end # module Facts