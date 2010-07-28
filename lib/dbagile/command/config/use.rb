module DbAgile
  class Command
    module Config
      #
      # Set the current database to use
      #
      # Usage: dba #{command_name} CONFIG
      #
      class Use < Command
        Command::build_me(self, __FILE__)
      
        # Database name
        attr_accessor :match
      
        # Returns command's category
        def category
          :config
        end
      
        # Normalizes the pending arguments
        def normalize_pending_arguments(arguments)
          self.match = valid_argument_list!(arguments, Symbol)
          self.match = valid_database_name!(self.match)
        end
      
        #
        # Executes the command.
        #
        # @return [DbAgile::Core::Database] the used database
        #
        def execute_command
          db = nil
          with_repository do |repository|
            db = has_database!(repository, self.match)

            # Makes it the current one
            repository.current_db_name = db.name
      
            # Flush the repository file
            repository.flush!
          end

          # List available databases now
          DbAgile::dba(environment){|dba| dba.config_list %w{}}
        
          # Return current database
          db
        end
      
      end # class Use
    end # module Config
  end # class Command
end # module DbAgile