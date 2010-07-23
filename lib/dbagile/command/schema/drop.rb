module DbAgile
  class Command
    module Schema
      #
      # Drop a table from the real SQL database
      #
      # Usage: dba #{command_name} TABLE
      # 
      class Drop < Command
        Command::build_me(self, __FILE__)
      
        # Table which must be dropped
        attr_accessor :table
      
        # Returns command's category
        def category
          :schema
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
      
      end # module Schema
    end # class Drop
  end # class Command
end # module DbAgile