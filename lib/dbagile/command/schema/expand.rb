module DbAgile
  class Command
    module Schema
      #
      # Apply schema:diff addition differences on the real database.
      #
      # Usage: dba #{command_name}
      #        dba #{command_name} REFERENCE
      #        dba #{command_name} DB1 DB2
      #
      # For more information about schema comparisons, try 'dba help schema:diff'
      #
      # WARNING: The current version of DbAgile is unable to infer some SQL database objects
      #          (like foreign keys) when using certain adapters. This may lead to subtle 
      #          errors. Don't hesitate to help (http://github.com/blambeau/dbagile).
      #
      class Expand < Command
        include Schema::ComparisonBased
        Command::build_me(self, __FILE__)
      
        # Expander options
        attr_reader :expander_options
        
        # Sets the default options
        def set_default_options
          @expander_options = {}
          @expander_options[:environment] = environment
          @expander_options[:friendly] = true
        end
      
        # Contribute to options
        def add_options(opt)
          opt.separator nil
          opt.separator "Options:"
          add_common_schema_options(opt)
          opt.on('--dry-run', "Trace SQL statements on STDOUT only, do nothing on the database") do |value|
            self.expander_options[:dry_run] = true
          end
        end
      
        # Normalizes the pending arguments
        def normalize_pending_arguments(arguments)
          normalize_comparison_arguments(arguments)
        end
        
        # Executes the command
        def execute_command
          ls, ld, rs, rd = left_and_right_schemas(true)
          show_minus(rd, rs, ld, ls, :add)
          minus = rs - ls
          if environment.ask("Are you sure? ") =~ /^\s*[Yy]([Ee][Ss])?/
            make_the_job(minus)
          end
          say("ok.")
        end
        
        def make_the_job(minus)
          with_connection(self.left){|conn|
            conn.transaction{|t|
              t.expand_schema(minus, expander_options)
            }
          }
        end
      
      end # class SchemaDump
    end # module Schema
  end # class Command
end # module DbAgile
