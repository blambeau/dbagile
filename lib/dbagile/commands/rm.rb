module DbAgile
  module Commands
    #
    # Removes a configuration in ~/.dbagile
    #
    class Rm < ::DbAgile::Commands::Command
      
      # Name of the configuration to add
      attr_accessor :match
      
      # Creates a command instance
      def initialize
        super
      end
      
      # Returns the command banner
      def banner
        "usage: dba rm NAME"
      end

      # Short help
      def short_help
        "Remove a configuration"
      end
      
      # Shows the help
      def show_help
        info banner
        info ""
        info short_help
        info ""
      end

      # Contribute to options
      def add_options(opt)
      end
      
      # Normalizes the pending arguments
      def normalize_pending_arguments(arguments)
        exit(nil, true) unless arguments.size == 1
        self.match = arguments.shift.to_sym
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
        DbAgile::Commands::List.new.run(nil, [])
      end
      
    end # class List
  end # module Commands
end # module DbAgile