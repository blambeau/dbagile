module DbAgile
  class Command
    #
    # Show help of a given command
    #
    class Help < Command
      
      # Name of the configuration to add
      attr_accessor :command
      
      # Returns command's category
      def category
        :dba
      end
      
      # Returns the command banner
      def banner
        "Usage: dba #{command_name} COMMAND"
      end

      # Short help
      def short_help
        "Show help for a specific command"
      end
      
      # Normalizes the pending arguments
      def normalize_pending_arguments(arguments)
        self.command = valid_argument_list!(arguments, String)
        self.command = has_command!(self.command, environment)
      end
      
      # Executes the command
      def execute_command
        say(command.options.to_s)
        say("")
        say("Description:")
        say("  " + command.short_help.to_s)
        say("")
      end
      
    end # class List
  end # class Command
end # module DbAgile