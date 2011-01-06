module DbAgile
  class Command
    module Schema
      #
      # Merge a list of schemas
      #
      # Usage: dba #{command_name} SCHEMA_ARG, ...
      #
      # This command merges all schema in arguments into a single schema and dumps the 
      # result in YAML on the output console. Schema arguments may be schema files or 
      # schemas installed on the current database [announced|effective|physical]. This 
      # command uses the fallback chain (announced -> effective -> physical) and has no 
      # side-effect on the database itself (read-only).
      #
      # NOTE: Schema-checking is on by default and applied on the resulting schema.
      #       This which may lead to checking errors when reverse engineering poorly 
      #       designed databases. Doing so immediately informs you about a potential 
      #       problem.
      #
      #       Use --no-check to bypass schema checking. See also schema:check.
      #
      class Merge < Command
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
          :multiple
        end
      
        # Executes the command
        def execute_command
          with_schemas(false) do |schemas|
            empty = DbAgile::Core::Schema::EMPTY_SCHEMA
            result = schemas.inject(empty){|memo,schema| memo + schema}
            if self.check_schemas
              result.check!
              say("# And the result is valid!", :green)
            end
            flush(result.to_yaml)
            result
          end
        end
      
      end # class SchemaDump
    end # module Schema
  end # class Command
end # module DbAgile
