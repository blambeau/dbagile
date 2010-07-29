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
