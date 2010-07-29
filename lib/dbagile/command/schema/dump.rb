module DbAgile
  class Command
    module Schema
      #
      # Dump a schema of the current database
      #
      # Usage: dba #{command_name} [announced|effective|physical]
      #
      # This command dumps the schema of the current database on the output console. 
      # Without argument, the announced schema is implicit. This command uses the 
      # fallback chain (announced -> effective -> physical) and has no side-effect 
      # on the database itself (read-only).
      #
      # NOTE: Schema-checking is on by default, which may lead to checking errors, 
      #       typically when reverse engineering poorly designed databases. Doing so 
      #       immediately informs you about a potential problem.
      #
      #       Use --no-check to bypass schema checking. See also schema:check.
      #
      class Dump < Command
        include Schema::Commons
        Command::build_me(self, __FILE__)
        
        # Contribute to options
        def add_options(opt)
          opt.separator nil
          opt.separator "Options:"
          add_check_options(opt)
        end
        
        # Returns :single
        def kind_of_schema_arguments
          :single
        end
      
        # Executes the command
        def execute_command
          with_schema do |schema|
            say("# Schema of #{schema.schema_identifier.inspect}", :magenta)
            display schema.to_yaml
            schema
          end
        end
      
      end # class SchemaDump
    end # module Schema
  end # class Command
end # module DbAgile
