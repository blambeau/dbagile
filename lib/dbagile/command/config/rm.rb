module DbAgile
  class Command
    module Config
      #
      # Remove a configuration in ~/.dbagile
      #
      # Usage: dba #{command_name} CONFIG
      #
      class Rm < Command
        Command::build_me(self, __FILE__)
      
        # Name of the configuration to add
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
        # @return [DbAgile::Core::Repository] the configuration file instance
        #
        def execute_command
          cf = with_repository do |config_file|
            config = has_database!(config_file, self.match)

            # Move the current one if it was it
            if config_file.current?(config)
              config_file.current_db_name = nil
            end
      
            # Removes it from file
            config_file.remove(config)
      
            # Flush the configuration file
            config_file.flush!
          end
        
          # List available databases now
          DbAgile::dba(environment){|dba| dba.config_list %w{}}
        
          # Returns config file
          cf
        end
      
      end # class Rm
    end # module Config
  end # class Command
end # module DbAgile