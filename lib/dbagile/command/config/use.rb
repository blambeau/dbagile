module DbAgile
  class Command
    module Config
      #
      # Set the current database configuration to use
      #
      # Usage: dba #{command_name} CONFIG
      #
      class Use < Command
        Command::build_me(self, __FILE__)
      
        # Name of the configuration to use
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
        # @return [DbAgile::Core::Database] the created configuration
        #
        def execute_command
          config = nil
          with_config_file do |config_file|
            config = has_database!(config_file, self.match)

            # Makes it the current one
            config_file.current_db_name = config.name
      
            # Flush the configuration file
            config_file.flush!
          end

          # List available databases now
          DbAgile::dba(environment){|dba| dba.config_list %w{}}
        
          # Return current configuration
          config
        end
      
      end # class Use
    end # module Config
  end # class Command
end # module DbAgile