module DbAgile
  class Command
    module Schema
      #
      # Print a SQL script for a creating/dropping a schema
      #
      # Usage: dba #{command_name} {create, drop} [SCHEMA_FILE]
      #
      class SqlScript < Command
        include SchemaBased
        Command::build_me(self, __FILE__)

        # Kinds of script
        SCRIPT_KIND = [:create, :drop]
        
        # Kind of script [:create, :drop]
        attr_accessor :script_kind
        
        # Contribute to options
        def add_options(opt)
          opt.separator nil
          opt.separator "Options:"
          add_effective_pysical_options(opt)
          add_check_options(opt)
        end
      
        # Normalizes the pending arguments
        def normalize_pending_arguments(arguments)
          case arguments.size
            when 0
              bad_argument_list!
            when 1
              self.script_kind = is_in!("script kind", arguments.shift, SCRIPT_KIND)
            when 2
              self.script_kind = is_in!("script kind", arguments.shift, SCRIPT_KIND)
              self.schema_file = valid_read_file!(arguments.shift)
            else
              bad_argument_list!(arguments)
          end
        end
        
        # Executes the command
        def execute_command
          script = with_schema{|schema|
            case self.script_kind
              when :create
                DbAgile::Core::Schema::create_script(schema)
              when :drop
                DbAgile::Core::Schema::drop_script(schema)
              else
                raise DbAgile::AssumptionFailedError, "Unknown script kind #{self.script_kind}"
            end
          }
          with_current_connection{|conn|
            conn.script2sql(script, environment.output_buffer)
          }
        end
      
      end # class CreateScript
    end # module Schema
  end # class Command
end # module DbAgile