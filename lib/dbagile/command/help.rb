module DbAgile
  class Command
    #
    # Show help of a given command
    #
    class Help < Command
      
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
      
      # Normalizes the pending arguments
      def normalize_pending_arguments(arguments)
        exit(nil, true) unless arguments.size == 1
        self.command = arguments.shift
      end
      
      # Executes the command
      def execute_command
        command = has_command!(self.command)
        display(command.short_help)
        display(command.options)
      end
      
    end # class List
  end # class Command
end # module DbAgile