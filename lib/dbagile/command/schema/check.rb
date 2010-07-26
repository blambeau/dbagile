module DbAgile
  class Command
    module Schema
      #
      # Check a relational schema
      #
      # Usage: dba #{command_name} [FILE]
      #
      # Without arguent, this command checks the announced schema of current database. 
      # With a single YAML file argument, loads the schema from file and checks it.
      #
      class Check < Command
        include Schema::SchemaBased
        Command::build_me(self, __FILE__)
      
        # Schema to check
        attr_accessor :schema
      
        # Contribute to options
        def add_options(opt)
          opt.separator nil
          opt.separator "Options:"
          add_effective_pysical_options(opt)
        end
        
        # Normalizes the pending arguments
        def normalize_pending_arguments(arguments)
          case arguments.size
            when 0
            when 1
              self.schema_file = valid_read_file!(arguments.shift)
            else
              bad_argument_list!(arguments)
          end
        end
        
        # Executes the command
        def execute_command
          with_schema do |schema|
            errors = schema.check!(false)
            say("\n")
            if errors.empty?
              say("Valid schema (#{schema.schema_identifier.inspect})!", :green)
              say("\n")
              schema
            else
              say("Invalid schema (#{schema.schema_identifier.inspect}):", :red)
              errors.error_messages.each{|m| say("  * #{m}")}
              say("\n")
              errors
            end
          end
        end
      
      end # class Check
    end # module Schema
  end # class Command
end # module DbAgile
