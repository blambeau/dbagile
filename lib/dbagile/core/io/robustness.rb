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
        # Asserts that a database exists inside a Repository instance. 
        # When db_name is nil, asserts that a default database is set.
        #
        # @param [DbAgile::Core::Repository] a repository
        # @return [DbAgile::Core::Database] the database instance when found.
        # @raise ArgumentError if repository is not a Repository instance
        # @raise DbAgile::NoSuchConfigError if the database cannot be found.
        # @raise DbAgile::NoDefaultConfigError if db_name is nil and no 
        #        current database is set on the repository.
        #
        def has_database!(repository, db_name = nil)
          raise ArgumentError, "Repository expected, got #{repository}"\
            unless repository.kind_of?(DbAgile::Core::Repository)
          db = if db_name.nil?
            repository.current_config
          else 
            repository.database(db_name)
          end
          if db.nil?
            raise DbAgile::NoSuchConfigError, "Unknown database #{db_name}" if db_name
            raise DbAgile::NoDefaultConfigError, "No default database set (try 'dba use ...' first)"
          else
            db
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