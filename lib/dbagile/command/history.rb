module DbAgile
  class Command
    #
    # Display command history
    #
    class History < Command
      
      # Returns command's category
      def category
        :dba
      end
      
      # Returns the command banner
      def banner
        "Usage: dba #{command_name}"
      end

      # Short help
      def short_help
        "Display dba command history"
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