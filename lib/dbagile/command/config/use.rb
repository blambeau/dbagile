module DbAgile
  class Command
    module Config
      #
      # Updates the current configuration to use
      #
      class Use < Command
      
        # Name of the configuration to use
        attr_accessor :match
      
        # Returns command's category
        def category
          :config
        end
      
        # Returns the command banner
        def banner
          "Usage: dba #{command_name} CONFIG"
        end

        # Short help
        def short_help
          "Set the current database configuration to use"
        end
      
        # Normalizes the pending arguments
        def normalize_pending_arguments(arguments)
          self.match = valid_argument_list!(arguments, Symbol)
          self.match = valid_configuration_name!(self.match)
        end
      
        #
        # Executes the command.
        #
        # @return [DbAgile::Core::Configuration] the created configuration
        #
        def execute_command
          config = nil
          with_config_file do |config_file|
            config = has_config!(config_file, self.match)

            # Makes it the current one
            config_file.current_config_name = config.name
      
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