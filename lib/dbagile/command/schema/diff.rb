module DbAgile
  class Command
    module Schema
      #
      # Show differences between database schemas
      #
      # Usage: dba #{command_name}
      #        dba #{command_name} REFERENCE
      #        dba #{command_name} DB1 DB2
      #
      # When used without any argument, shows the differences between the schema inside
      # the SQL database (left) of the current configuration and the schema files (right).
      #
      # When used with one configuration name (REFERENCE), shows the differences between
      # the schema of the current configuration and the schema of REFERENCE.
      #
      # When used with two configuration names (DB1 and DB2), shows the differences between
      # the schemas of the respective databases.
      #
      # WARNING: The current version of DbAgile is unable to infer some SQL database objects
      #          (like foreign keys) when using certain adapters. In contrast, comparing 
      #          schema files is safe. Therefore, in the second and third cases, if schema 
      #          files are installed, they have the prirory. Use --real option to override 
      #          this behavior. 
      #
      class Diff < Command
        include Schema::ComparisonBased
        Command::build_me(self, __FILE__)
      
        # Contribute to options
        def add_options(opt)
          opt.separator nil
          opt.separator "Options:"
          add_common_schema_options(opt)
        end
      
        # Normalizes the pending arguments
        def normalize_pending_arguments(arguments)
          normalize_comparison_arguments(arguments)
        end
        
        # Shows the minus
        def show_minus(left_debug, left_schema, right_debug, right_schema, kind)
          size = 20 + DbAgile::MathTools::max(left_debug.to_s.length, right_debug.to_s.length)
          color = (kind == :add ? :green : :red)
          say "#"*size
          say "### LEFT: #{left_debug}"
          say "### RIGHT: #{right_debug}"
          say "### Objects to #{kind} on LEFT", color
          say "#"*size
          say "\n"
          minus = (left_schema - right_schema)
          if minus.empty?
            say("nothing to do", :blue)
            say "\n"
          else
            say(minus.to_yaml, color)  
          end
          say ""
        end
      
        # Executes the command
        def execute_command
          if left == right
            left_schema, left_debug = real_schema_of(self.left)
            right_schema, right_debug = files_schema_of(self.right)
          else
            left_schema, left_debug = schema_of(self.left)
            right_schema, right_debug = schema_of(self.right)
          end
          show_minus(left_debug, left_schema, right_debug, right_schema, :remove)
          show_minus(right_debug, right_schema, left_debug, left_schema, :add)
        end
      
      end # class SchemaDump
    end # module Schema
  end # class Command
end # module DbAgile
