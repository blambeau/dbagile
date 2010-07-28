module DbAgile
  class Command
    module Schema
      #
      # Print a create SQL script for a given schema
      #
      # Usage: dba #{command_name} [SCHEMA_FILE]
      #
      class CreateScript < Command
        include SchemaBased
        Command::build_me(self, __FILE__)
        
        # Executes the command
        def execute_command
          with_schema{|schema|
            schema.check!
            script = DbAgile::Core::Schema::create_script(schema)
            with_current_connection{|conn|
              conn.script2sql(script, environment.output_buffer)
            }
          }
        end
      
      end # class CreateScript
    end # module Schema
  end # class Command
end # module DbAgile