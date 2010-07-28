module DbAgile
  module Core
    module IO
      class DSL
        include DbAgile::Core::IO::Robustness
        
        # The Repository instance passed at construction
        attr_reader :repository
        
        # The current Database instance
        attr_reader :current_database
        
        # Creates a DSL instance
        def initialize(repository = nil, database = nil, &block)
          @repository = repository
          @current_database = database
          self.instance_eval(&block) unless block.nil?
        end
        
        # Adds a configuration under a given name
        def database(name, &block)
          valid_database_name!(name)
          created = with_database(Core::Database.new(name)){|cfg|
            self.instance_eval(&block)
            cfg
          }
          unless repository.nil?
            repository << created
          end
          created
        end
        
        # Sets the database uri on the current configuration
        def uri(str)
          dsl_has_database!
          valid_database_uri!(str)
          current_database.uri = str
        end
        
        # Sets the announced schema files
        def announced_schema(*files)
          dsl_has_database!
          current_database.announced_files = valid_schema_files!(files)
        end
        
        # Sets the effective schema files
        def effective_schema(*files)
          dsl_has_database!
          current_database.effective_files = valid_schema_files!(files)
        end
        
        # @see DbAgile::Core::Database#plug
        def plug(*args)
          dsl_has_database!
          current_database.plug(*args)
        end
        
        # Sets the current configuration
        def current_db(name)
          dsl_has_repository!
          repository.current_config_name = name
        end
        
        ###
        
        private 

        # Yields the block with a database
        def with_database(db)
          if db.kind_of?(DbAgile::Core::Database)
            @current_database = db
            result = yield(db)
            @current_database = nil
            result
          elsif db.kind_of?(Symbol) or db.nil?
            dsl_has_repository!
            has_config!(config_file, cfg)
            with_database(repository.config(cfg), &block)
          end
        end
        
        # Asserts that there is a current configuration
        def dsl_has_database!
          raise DbAgile::Error, "Invalid Core::IO::DSL usage, no current database" if current_database.nil?
        end
        
        # Asserts that there is a current config file
        def dsl_has_repository!
          raise DbAgile::Error, "Invalid Core::IO::DSL usage, no current repository" if repository.nil?
        end
        
      end # class DSL
    end # module IO
  end # module Core
end # module DbAgile