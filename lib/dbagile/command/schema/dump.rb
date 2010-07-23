module DbAgile
  class Command
    module Schema
      #
      # Dump the schema of the database
      #
      # Usage: dba #{command_name}
      #
      class Dump < Command
        Command::build_me(self, __FILE__)
      
        # Returns command's category
        def category
          :schema
        end

        # Executes the command
        def execute_command
          schema = nil
          with_current_connection do |connection|
            schema = connection.database_schema
            display schema.to_yaml
          end
          schema
        end
      
      end # class SchemaDump
    end # module Schema
  end # class Command
end # module DbAgile
