module DbAgile
  class Command
    module Schema
      #
      # Flush a SQL script for a creating/dropping/staging a schema
      #
      # Usage: dba #{command_name} {create, drop, stage} [SCHEMA_ARG, ...]
      #
      # dba #{command_name} create [announced|effective|physical|FILE.yaml]
      #
      #   Flush a SQL script for creating a SQL database from a schema. Announced
      #   schema of the database is the default. This command uses the fallback chain 
      #   (announced -> effective -> physical) and has no side-effect on the database 
      #   itself (read-only).
      #
      # dba #{command_name} drop [announced|effective|physical|FILE.yaml]
      #
      #   Flush a SQL script for dropping all objects of a SQL database. Announced
      #   schema of the database is the default. This command uses the fallback chain 
      #   (announced -> effective -> physical) and has no side-effect on the database 
      #   itself (read-only).
      #
      # dba #{command_name} stage [schema1 schema2]
      #
      #   Flush a SQL script for staging a database from schema1 to schema2. Arguments 
      #   can be installed schemas of the current database or schema files. Effective 
      #   and announced schema of the current database are respectively used by default. 
      #   The command uses the fallback chain (announced -> effective -> physical) and 
      #   has no side-effect on the current database itself (read-only).
      #
      # Schema-checking is on by default, which may lead to checking errors, typically 
      # when reverse engineering poorly designed databases. Doing so immediately informs 
      # you about a potential problem.
      #
      # Use --no-check to bypass schema checking. See also schema:check.
      #
      class SqlScript < Command
        include Schema::Commons
        Command::build_me(self, __FILE__)

        # Kinds of script
        SCRIPT_KIND = [:create, :drop, :stage]
        
        # Kind of script [:create, :drop, :stage]
        attr_accessor :script_kind
        
        # Contribute to options
        def add_options(opt)
          opt.separator nil
          opt.separator "Options:"
          add_check_options(opt)
        end
        
        # Returns :single
        def kind_of_schema_arguments
          if script_kind == :stage
            :double
          else
            :single
          end
        end
      
        # Normalizes the pending arguments
        def normalize_pending_arguments(arguments)
          case arguments.size
            when 0
              bad_argument_list!(arguments, "script kind")
            else
              self.script_kind = is_in!("script kind", arguments.shift, SCRIPT_KIND)
              normalize_schema_arguments(arguments)
          end
        end
        
        # Executes the command
        def execute_command
          case kind_of_schema_arguments
            when :single
              execute_single_command
            when :double
              execute_double_command
          end
        end
          
        # Execution for :create and :drop
        def execute_single_command
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
      
        # Execution for :stage
        def execute_double_command
          script = with_schemas{|left, right|
            case self.script_kind
              when :stage
                merged = left + right
                script = DbAgile::Core::Schema::stage_script(merged)
                if merged.status == DbAgile::Core::Schema::NO_CHANGE
                  say("Nothing to stage", :magenta)
                end
                script
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