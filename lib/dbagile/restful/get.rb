module DbAgile
  class Restful
    module Get
      
      # Implements GET access of the restful interface
      def get(env)
        request = Rack::Request.new(env)
        case request.path.strip[1..-1]
          when ''
            return _copyright_(env)
          when /(\w+)\/(\w+)\.(\w+)$/
            if format = known_extension?($3)
              content_type = known_format?(format)
              db, table, buffer = $1, $2, StringIO.new
              projection = get_to_tuple(request.GET)
              with_connection(db.to_sym) do |connection|
                method = "to_#{format}".to_sym
                connection.dataset($2.to_sym, projection).send(method, buffer)
              end
              return _200_(env, content_type, [ buffer.string ])
            end
        end
        return _404_(env)
      rescue DbAgile::InvalidConfigurationName,
             DbAgile::NoSuchConfigError,
             DbAgile::NoSuchTableError
        return _404_(env)
      end
      
    end # module Get
  end # class Restful
end # module Facts