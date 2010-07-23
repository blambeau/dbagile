module DbAgile
  class Command
    module Schema
      module ComparisonBased
        
        # Use real schema?
        attr_accessor :real
      
        # Left of the comparison
        attr_accessor :left
      
        # Right of the comparison
        attr_accessor :right
      
        # Returns command's category
        def category
          :schema
        end

        # Installs options that are common to all schema commands
        def add_common_schema_options(opt)
          opt.on("--real", "Bypass schema files") do |value|
            self.real = true
          end
        end
          
        # Normalizes the pending arguments
        def normalize_comparison_arguments(arguments)
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
        
        # Returns left and right schemas
        def left_and_right_schemas(debug = false)
          if left == right
            left_schema, left_debug = real_schema_of(self.left)
            right_schema, right_debug = files_schema_of(self.right)
          else
            left_schema, left_debug = schema_of(self.left)
            right_schema, right_debug = schema_of(self.right)
          end
          if debug
            [ left_schema, left_debug, right_schema, right_debug ]
          else
            [ left_schema, right_schema ]
          end
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
      
      end # module ComparisonBased
    end # module Schema
  end # class Command
end # module DbAgile