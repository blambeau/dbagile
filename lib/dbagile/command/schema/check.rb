module DbAgile
  class Command
    module Schema
      #
      # Checks a relational schema
      #
      # Usage: dba #{command_name} [FILE]
      #
      # Without arguent, this command checks the announced schema of current database. 
      # With a single YAML file argument, loads the schema from file and checks it.
      #
      class Check < Command
        include Schema::ComparisonBased
        Command::build_me(self, __FILE__)
      
        # Schema to check
        attr_accessor :schema
      
        # Output options
        attr_reader :output_options
      
        # Sets the default options
        def set_default_options
          @output_options = {}
        end
    
        # Normalizes the pending arguments
        def normalize_pending_arguments(arguments)
          case arguments.size
            when 0
              self.schema = with_current_config{|config| config.announced_schema(true)}
            when 1
              file = valid_read_file!(arguments.shift)
              self.schema = DbAgile::Core::Schema::yaml_file_load(file)
              self.schema.schema_identifier = file
            else
              bad_argument_list!(arguments)
          end
        end
        
        # Executes the command
        def execute_command
          errors = self.schema.check!(false)
          say("\n")
          if errors.empty?
            say("Valid schema (#{schema.schema_identifier})!", :green)
            say("\n")
            return self.schema
          else
            say("Invalid schema (#{schema.schema_identifier}):", :red)
            errors.error_messages.each{|m| say("  * #{m}")}
            say("\n")
            return errors
          end
        end
      
      end # class Check
    end # module Schema
  end # class Command
end # module DbAgile
