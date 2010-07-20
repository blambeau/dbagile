module DbAgile
  class Command
    class Drop < Command
      
      # Table which must be dropped
      attr_accessor :table
      
      # Returns command's category
      def category
        :schema
      end

      # Returns the command banner
      def banner
        "Usage: dba drop TABLE"
      end

      # Short help
      def short_help
        "Drop a table"
      end
      
      # Normalizes the pending arguments
      def normalize_pending_arguments(arguments)
        self.table = valid_argument_list!(arguments, Symbol)
      end
      
      # Executes the command
      def execute_command
        with_current_connection do |connection|
          connection.transaction do |t|
            t.drop_table(self.table)
          end
        end
      end
      
    end # class List
  end # class Command
end # module DbAgile