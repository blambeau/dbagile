module DbAgile
  class Command
    #
    # Updates the current configuration to use
    #
    class Use < Command
      
      # Name of the configuration to use
      attr_accessor :match
      
      # Returns the command banner
      def banner
        "usage: dba use CONFIG"
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
      
      # Executes the command
      def execute_command
        # load the configuration file
        config_file = DbAgile::load_user_config_file(DbAgile::user_config_file, true)
        config = has_config!(config_file, self.match)

        # Makes it the current one
        config_file.current_config_name = config.name
      
        # Flush the configuration file
        config_file.flush!

        # List available databases now
        DbAgile::Command::API.list([], environment)
      end
      
    end # class List
  end # class Command
end # module DbAgile