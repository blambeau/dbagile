module DbAgile
  class Command
    module SQL
      #
      # Drop a table from a SQL database
      #
      # Usage: dba #{command_name} TABLE
      #
      # This command issues a "DROP TABLE ..." in the DbAgile's command chain, therefore
      # targetting the schema of the physical SQL database and bypassing other schemas if
      # present (announced and effectice schemas in particular). 
      #
      # As it may lead to divergences between schemas, and between effective and physical 
      # schemas in particular, you should consider using schema:* commands instead, when 
      # possible.
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
      
      end # class Drop
    end # module SQL
  end # class Command
end # module DbAgile