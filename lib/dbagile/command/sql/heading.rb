module DbAgile
  class Command
    module SQL
      #
      # Show the heading of a table
      #
      # Usage: dba #{command_name} TABLE
      #
      # This commands shows a list with columns names and types for a given table
      # of the current SQL database.
      #
      class Heading < Command
        Command::build_me(self, __FILE__)
      
        # Table whose heading must be displayed
        attr_accessor :dataset
      
        # Returns command's category
        def category
          :sql
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
      end # class Heading
    end # # module SQL
  end # class Command
end # module DbAgile