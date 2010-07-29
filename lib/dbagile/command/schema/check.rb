module DbAgile
  class Command
    module Schema
      #
      # Check a database schema
      #
      # Usage: dba #{command_name} [SCHEMA.yaml|announced|effective|physical]
      #
      # This command informs you about bad smells and good practices with relational
      # schemas (i.e. forgetting to create keys, not providing unique constraint 
      # names, and so on).
      # 
      # dba #{command_name} SCHEMA.yaml
      #
      #   Load the schema from file and check it, printing advices and errors on the 
      #   message console. The command does not connect any database in this mode.
      #
      # dba #{command_name} [announced|effective|physical]
      #
      #   Checks a schema of the current database. Announced schema is implicit without
      #   any argument. This command uses a fallback chain (announced -> effective -> 
      #   physical) and has no side-effect on the database itself (read-only).
      #
      class Check < Command
        include Schema::Commons
        Command::build_me(self, __FILE__)
        
        # Returns :single
        def kind_of_schema_arguments
          :single
        end
      
        # Contribute to options
        def add_options(opt)
          self.check_schemas = false
        end
        
        # Executes the command
        def execute_command
          with_schema do |schema|
            errors = schema.check!(false)
            say("\n")
            if errors.empty?
              say("Valid schema (#{schema.schema_identifier.inspect})!", :green)
              say("\n")
              [ schema, errors ]
            else
              say("Invalid schema (#{schema.schema_identifier.inspect}):", :red)
              errors.error_messages.each{|m| say("  * #{m}")}
              say("\n")
              [ schema, errors ]
            end
          end
        end
      
      end # class Check
    end # module Schema
  end # class Command
end # module DbAgile
