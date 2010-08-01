module DbAgile
  class Command
    module Db
      #
      # Adds a new database configuration
      #
      # Usage: dba #{command_name} NAME URI
      #
      class Add < Command
        Command::build_me(self, __FILE__)
      
        # Database name
        attr_accessor :db_name
      
        # Database URI 
        attr_accessor :uri
      
        # Makes it the current database?
        attr_accessor :current
      
        # Sets the default options
        def set_default_options
          @current = true
        end
      
        # Contribute to options
        def add_options(opt)
          opt.separator nil
          opt.separator "Options:"
          opt.on("--[no-]current", "Set as current database when created (see use)") do |value|
            self.current = false
          end
        end
      
        # Normalizes the pending arguments
        def normalize_pending_arguments(arguments)
          self.db_name, self.uri = valid_argument_list!(arguments, Symbol, String)
        end
      
        # Checks command 
        def check_command
          valid_database_name!(self.db_name)
          valid_database_uri!(self.uri)
        end
      
        #
        # Executes the command.
        #
        # @return [DbAgile::Core::Database] the created database
        #
        def execute_command
          db = nil
          with_repository do |repository|
        
            if repository.has_database?(self.db_name)
              raise DatabaseNameConflictError, "Database #{self.db_name} already exists"
            else
              # Create the database and adds it
              name, uri = self.db_name, self.uri
              db = DbAgile::Core::Database.new(name, uri)
              repository << db
              infer_schemas(db) if db.ping?
        
              # Makes it the current one if requested
              if self.current
                repository.current_db_name = db.name 
              end
        
              # Flush the repository file
              repository.save!
            end
          
          end

          # List available databases now
          DbAgile::dba(environment){|dba| dba.db_list %w{}}
        
          # Returns created database
          db
        end
        
        # Infers database schemas
        def infer_schemas(db)
          schema = db.physical_schema
          db.set_announced_schema(schema)
          db.set_effective_schema(schema)
        rescue => ex
          say("An error occured when infering schema: #{ex.message}\nYou'll have to install them manually. Sorry", :magenta)
        end
      
      end # class Add
    end # module Db
  end # class Command
end # module DbAgile