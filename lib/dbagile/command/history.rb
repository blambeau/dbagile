module DbAgile
  class Command
    #
    # Display 'dba' command history
    #
    # Usage: dba #{command_name}
    #
    class History < Command
      Command::build_me(self, __FILE__)
      
      # Returns command's category
      def category
        :dba
      end
      
      # Normalizes the pending arguments
      def normalize_pending_arguments(arguments)
        bad_argument_list!(arguments) unless arguments.empty?
      end
      
      # Executes the command
      def execute_command
        h, i = environment.history, 0
        display h.collect{|c| "#{(i += 1) - 1}: #{c}"}.join("\n")
        h
      end
      
    end # class List
  end # class Command
end # module DbAgile