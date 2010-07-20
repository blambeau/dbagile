module DbAgile
  class Command
    #
    # Shows the heading of a table
    #
    class Heading < Command
      
      # Table whose heading must be displayed
      attr_accessor :dataset
      
      # Returns command's category
      def category
        :schema
      end

      # Returns the command banner
      def banner
        "Usage: dba heading TABLE"
      end

      # Short help
      def short_help
        "Shows the heading of a table"
      end
      
      # Normalizes the pending arguments
      def normalize_pending_arguments(arguments)
        self.dataset = valid_argument_list!(arguments, Symbol)
      end
      
      # Executes the command
      def execute_command
        with_current_connection do |connection|
          heading = connection.heading(self.dataset)
          display("{\n" + heading.collect{|pair| "  #{pair[0]}: #{pair[1]}"}.join(",\n") + "\n}\n")
          heading
        end
      end
      
    end # class List
  end # class Command
end # module DbAgile