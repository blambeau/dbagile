module DbAgile
  class Command
    module Schema
      #
      # Dumps the schema of a database
      #
      class Dump < Command
      
        # Returns command's category
        def category
          :schema
        end

        # Returns the command banner
        def banner
          "Usage: dba #{command_name}"
        end

        # Short help
        def short_help
          "Dumps the schema of the database"
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
