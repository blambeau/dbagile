module DbAgile
  class Command
    module Repo
      #
      # Remove a database configuration from the repository
      #
      # Usage: dba #{command_name} CONFIG
      #
      class Rm < Command
        Command::build_me(self, __FILE__)
      
        # Name of the database to remove
        attr_accessor :match
      
        # Normalizes the pending arguments
        def normalize_pending_arguments(arguments)
          self.match = valid_argument_list!(arguments, Symbol)
          self.match = valid_database_name!(self.match)
        end
      
        #
        # Executes the command.
        #
        # @return [DbAgile::Core::Repository] the repository instance
        #
        def execute_command
          cf = with_repository do |repository|
            db = has_database!(repository, self.match)

            # Move the current one if it was it
            if repository.current?(db)
              repository.current_db_name = nil
            end
      
            # Removes it from file
            repository.remove(db)
      
            # Flush the repository file
            repository.flush!
          end
        
          # List available databases now
          DbAgile::dba(environment){|dba| dba.repo_list %w{}}
        
          # Returns repository
          cf
        end
      
      end # class Rm
    end # module Repo
  end # class Command
end # module DbAgile