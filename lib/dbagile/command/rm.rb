module DbAgile
  class Command
    #
    # Removes a configuration in ~/.dbagile
    #
    class Rm < Command
      
      # Name of the configuration to add
      attr_accessor :match
      
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
        # load the configuration file
        config_file = DbAgile::load_user_config_file(DbAgile::user_config_file, true)
        config = has_config!(config_file, self.match)

        # Move the current one if it was it
        if config_file.current?(config)
          config_file.current_config_name = nil
        end
      
        # Removes it from file
        config_file.remove(config)
      
        # Flush the configuration file
        config_file.flush!

        # List available databases now
        DbAgile::Command::List.new.run(nil, [])
      end
      
    end # class List
  end # class Command
end # module DbAgile