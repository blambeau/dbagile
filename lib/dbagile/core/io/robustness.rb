module DbAgile
  module Core
    module IO
      module Robustness
        
        #
        # Asserts that a database name is valid or raises a InvalidConfigurationName 
        # error. A valid database name is a Symbol that matches /[a-z][a-z0-9_]*/.
        #
        # @returns [Symbol] name
        # @raise DbAgile::InvalidConfigurationName if assertion fails
        #
        def valid_database_name!(name)
          raise DbAgile::InvalidConfigurationName, "Invalid database name #{name}"\
            unless name.kind_of?(Symbol) and /[a-z][a-z0-9_]*/ =~ name.to_s
          name
        end
      
        # 
        # Asserts that a database uri is valid or raises a InvalidDatabaseUri error.
        #
        # A valid database uri is any valid absolute URI (for now, will be restricted 
        # to known adapters in the future).
        #
        # @return [String] uri
        # @raise DbAgile::InvalidDatabaseUri if assertion fails
        #
        def valid_database_uri!(uri)
          require 'uri'
          got = URI::parse(uri)
          if got.scheme or (uri =~ /\.db$/)
            uri
          else
            raise DbAgile::InvalidDatabaseUri, "Invalid database uri: #{uri}"
          end
        rescue URI::InvalidURIError
          raise DbAgile::InvalidDatabaseUri, "Invalid database uri: #{uri}"
        end
        
        #
        # Asserts that a configuration exists inside a Repository instance. 
        # When config_name is nil, asserts that a default configuration is set.
        #
        # @return [DbAgile::Core::Database] the configuration instance when 
        # found.
        # @raise ArgumentError if config_file is not a Repository instance
        # @raise DbAgile::NoSuchConfigError if the configuration cannot be found.
        # @raise DbAgile::NoDefaultConfigError if config_name is nil and no 
        #        current configuration is set on the config file.
        #
        def has_config!(config_file, config_name = nil)
          raise ArgumentError, "Repository expected, got #{config_file}"\
            unless config_file.kind_of?(DbAgile::Core::Repository)
          config = if config_name.nil?
            config_file.current_config
          else 
            config_file.database(config_name)
          end
          if config.nil?
            raise DbAgile::NoSuchConfigError, "Unknown configuration #{config_name}" if config_name
            raise DbAgile::NoDefaultConfigError, "No default configuration set (try 'dba use ...' first)"
          else
            config
          end
        end
        
        # 
        # Coerces and asserts that schema files arguments are correct. 
        # Returns normalized version.
        #
        def valid_schema_files!(*files)
          files = files.flatten
          unless files.all?{|f| f.kind_of?(String)}
            raise DbAgile::CorruptedConfigFileError, "Invalid schema files #{files.inspect}"
          end
          files
        end
      
      end # module Robustness
    end # module IO
  end # module Core
end # module DbAgile