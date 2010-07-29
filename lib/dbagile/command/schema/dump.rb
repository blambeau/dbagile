module DbAgile
  class Command
    module Schema
      #
      # Dump database schema (announced by default) 
      #
      # Usage: dba #{command_name} [--effective|--physical]
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
