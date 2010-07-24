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
      
        # Normalizes the pending arguments
        def normalize_pending_arguments(arguments)
          normalize_comparison_arguments(arguments)
        end
        
        # Executes the command
        def execute_command
          with_current_config{|config|
            left  = config.announced_schema(true)
            right = config.effective_schema(true)
            show_minus(left, right, :add)
            show_minus(right, right, :remove)
          }
        end
      
      end # class SchemaDump
    end # module Schema
  end # class Command
end # module DbAgile
