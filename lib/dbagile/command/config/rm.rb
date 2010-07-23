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
          self.match = valid_configuration_name!(self.match)
        end
      
        #
        # Executes the command.
        #
        # @return [DbAgile::Core::Configuration::File] the configuration file instance
        #
        def execute_command
          cf = with_config_file do |config_file|
            config = has_config!(config_file, self.match)

            # Move the current one if it was it
            if config_file.current?(config)
              config_file.current_config_name = nil
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