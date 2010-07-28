module DbAgile
  class Command
    module Schema
      #
      # Print a drop SQL script for a given schema
      #
      # Usage: dba #{command_name} [SCHEMA_FILE]
      #
      class DropScript < Command
        include SchemaBased
        Command::build_me(self, __FILE__)
        
        # Contribute to options
        def add_options(opt)
          opt.separator nil
          opt.separator "Options:"
          add_effective_pysical_options(opt)
          add_check_options(opt)
        end
      
        # Executes the command
        def execute_command
          with_schema{|schema|
            if self.check_schema
              schema.check! 
            end
            script = DbAgile::Core::Schema::drop_script(schema)
            with_current_connection{|conn|
              conn.script2sql(script, environment.output_buffer)
            }
          }
        end
      
      end # class CreateScript
    end # module Schema
  end # class Command
end # module DbAgile