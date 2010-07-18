module DbAgile
  class Command
    #
    # Removes a configuration in ~/.dbagile
    #
    class Rm < Command
      
      # Name of the configuration to add
      attr_accessor :match
      
      # Returns command's category
      def category
        :configuration
      end
      
      # Returns the command banner
      def banner
        "usage: dba rm CONFIG"
      end

      # Short help
      def short_help
        "Remove a database configuration"
      end
      
      # Normalizes the pending arguments
      def normalize_pending_arguments(arguments)
        self.match = valid_argument_list!(arguments, Symbol)
        self.match = valid_configuration_name!(self.match)
      end
      
      # Executes the command
      def execute_command
        with_config_file do |config_file|
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
        DbAgile::Command::list %w{}, environment
      end
      
    end # class List
  end # class Command
end # module DbAgile