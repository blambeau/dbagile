module DbAgile
  class Restful
    module Get
      
      # Implements GET access of the restful interface
      def get(env)
        case env['PATH_INFO'].strip[1..-1]
          when ''
            return _copyright_(env)
          when /(\w+)\/(\w+)\.(\w+)$/
            if content_type = known_format?($3.to_sym)
              db, table, format = $1, $2, $3
              buffer = StringIO.new
              with_config(db.to_sym) do |config|
                method = "to_#{format}".to_sym
                config.connect.dataset($2.to_sym).send(method, buffer)
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