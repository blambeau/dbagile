module DbAgile
  module Commands
    #
    # Show help of a given command
    #
    class Help < ::DbAgile::Commands::Command
      
      # Name of the configuration to add
      attr_accessor :command
      
      # Returns the command banner
      def banner
        "usage: dba help COMMAND"
      end

      # Short help
      def short_help
        "Show help for a specific command"
      end
      
      # Shows the help
      def show_help
        info banner
        info ""
        info short_help
        info ""
      end

      # Normalizes the pending arguments
      def normalize_pending_arguments(arguments)
        exit(nil, true) unless arguments.size == 1
        self.command = arguments.shift
      end
      
      # Executes the command
      def execute_command
        command = has_command!(self.command)
        info(command.short_help.to_s)
        info(command.options.to_s)
      end
      
    end # class List
  end # module Commands
end # module DbAgile