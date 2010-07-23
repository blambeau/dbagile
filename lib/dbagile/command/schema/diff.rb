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
        Command::build_me(self, __FILE__)
      
        # Left of the comparison
        attr_accessor :left
      
        # Right of the comparison
        attr_accessor :right
      
        # Use real schema?
        attr_accessor :real
      
        # Returns command's category
        def category
          :schema
        end

        # Contribute to options
        def add_options(opt)
          opt.separator nil
          opt.separator "Options:"
          opt.on("--real", "Bypass schema files") do |value|
            self.real = true
          end
        end
      
        # Normalizes the pending arguments
        def normalize_pending_arguments(arguments)
          with_config_file do |file|
            case arguments.size
              when 0
                self.left = self.right = has_config!(file)
              when 1
                name = valid_argument_list!(arguments, Symbol)
                self.left  = has_config!(file)
                self.right = has_config!(file, valid_configuration_name!(name))
              when 2
                lname, rname = valid_argument_list!(arguments, Symbol, Symbol)
                self.left  = has_config!(file, valid_configuration_name!(lname))
                self.right = has_config!(file, valid_configuration_name!(rname))
              else
                bad_argument_list!(arguments)
            end
          end
        end
        
        # Returns the real schema of a configuration
        def real_schema_of(cfg)
          with_connection(cfg){|conn|
            [ conn.database_schema, cfg.uri ]
          }
        end
      
        # Returns the files schema of a configuration
        def files_schema_of(cfg)
          has_schema_files!(cfg)
          [ cfg.schema, cfg.name ]
        end
        
        # Returns real schema if --real has been set, the files
        # schemas otherwise
        def schema_of(cfg)
          if self.real or not(cfg.has_schema_files?)
            real_schema_of(cfg) 
          else 
            files_schema_of(cfg)
          end
        end
      
        # Shows the minus
        def show_minus(left_debug, left_schema, right_debug, right_schema, kind)
          size = 20 + DbAgile::MathTools::max(left_debug.length, right_debug.length)
          color = (kind == :add ? :green : :red)
          say "#"*size
          say "### LEFT: #{left_debug}"
          say "### RIGHT: #{right_debug}"
          say "### Objects to #{kind}", color
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
          show_minus(left_debug, left_schema, right_debug, right_schema, :add)
          show_minus(right_debug, right_schema, left_debug, left_schema, :remove)
        end
      
      end # class SchemaDump
    end # module Schema
  end # class Command
end # module DbAgile
