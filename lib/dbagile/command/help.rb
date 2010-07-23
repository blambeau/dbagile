module DbAgile
  class Command
    #
    # Show help of a given command
    #
    # Usage: dba #{command_name} COMMAND
    #
    class Help < Command
      Command::build_me(self, __FILE__)
      
      # Name of the configuration to add
      attr_accessor :command
      
      # Returns command's category
      def category
        :dba
      end
      
      # Normalizes the pending arguments
      def normalize_pending_arguments(arguments)
        self.command = valid_argument_list!(arguments, String)
        self.command = has_command!(self.command, environment)
      end
      
      # Executes the command
      def execute_command
        say(command.usage.to_s)
        say("")
        say("Description:")
        say("  " + command.summary.to_s)
        say(command.options.summarize.join)
        say("")
      end
      
    end # class List
  end # class Command
end # module DbAgile