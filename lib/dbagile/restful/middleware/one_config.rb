module DbAgile
  module Restful
    class Middleware
      # 
      # Rack middleware that provide access to a database using a config 
      # instance (DbAgile::Core::Configuration)
      #
      class OneConfig
        include Middleware::Utils
        include Middleware::Get
        include Middleware::Post
        include Middleware::Delete
        
        # Database configuration
        attr_reader :config
        
        # Creates a middleware instance
        def initialize(config)
          raise ArgumentError unless config.kind_of?(DbAgile::Core::Configuration)
          @config = config
        end
        
        # Decodes a path and yield the block with a connection and the 
        # requested format
        def decode(env)
          case env['PATH_INFO'].strip[1..-1]
            when ''
              _copyright_(env)
            when /(\w+)(\.(\w+))?$/
              table = $1.to_sym
            
              # Handle format
              format = nil
              if $2
                format = known_extension?($2)
                return _404_(env) unless format
              end
            
              format, body = config.with_connection do |connection|
                yield(connection, table, format) 
              end
              
              content_type = DbAgile::IO::FORMAT_TO_CONTENT_TYPE[format]
              _200_(env, content_type, body)
            else
              _404_(env)
          end
        rescue DbAgile::InvalidConfigurationName,
               DbAgile::NoSuchConfigError,
               DbAgile::NoSuchTableError => ex
          _404_(env, ex)
        rescue DbAgile::Error, Sequel::Error => ex
          if ex.message =~ /exist/
            _404_(env)
          else
            raise
          end
        end
      
        # Rack handler
        def call(env)
          method = env['REQUEST_METHOD'].downcase.to_sym
          if self.respond_to?(method)
            result = self.send(method, env)
          else
            puts "Unsupported restful method #{env['REQUEST_METHOD']}"
            [
              500, 
              {'Content-Type' => 'text/plain'},
              ["Unsupported restful method #{env['REQUEST_METHOD']}"]
            ]
          end
        rescue Exception => ex
          puts ex.message
          puts ex.backtrace.join("\n")
          [500, {'Content-Type' => 'text/plain'}, [ex.message]]
        end
        
      end # class OneConfig
    end # class Middleware
  end # module Restful
end # module DbAgile