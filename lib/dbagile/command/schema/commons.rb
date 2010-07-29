module DbAgile
  class Command
    module Schema
      module Commons
        
        # Checks schema(s) first?
        attr_accessor :check_schemas
      
        # Schema arguments
        attr_accessor :schema_arguments
      
        # Adds --[no-]check option
        def add_check_options(opt)
          self.check_schemas = true
          opt.on('--[no-]check', "Perform/Bypass schema checking") do |value|
            self.check_schemas = value
          end
        end
        
        # Normalizes a schema argument
        def normalize_schema_argument(argument)
          if File.exists?(argument) and File.file?(argument)
            argument
          else
            is_in!("schema", argument, [:announced, :effective, :physical])
          end
        end
        
        # Normalizes the pending arguments
        def normalize_schema_arguments(arguments)
          @schema_arguments = case kind_of_schema_arguments
            when :single
              if arguments.empty?
                [ :announced ]
              elsif arguments.size == 1
                arguments.collect{|arg| normalize_schema_argument(arg) }
              else
                bad_argument_list!(arguments)
              end
            when :double
              if arguments.empty?
                [ :announced, :effective ]
              elsif arguments.size == 2
                arguments.collect{|arg| normalize_schema_argument(arg) }
              else
                bad_argument_list!(arguments)
              end
            when :multiple
              if arguments.size >= 2
                arguments.collect{|arg| normalize_schema_argument(arg) }
              else
                bad_argument_list!(arguments)
              end
            else
              assumption_error!("Unexpected kind of schema argument #{kind_of_schema_arguments}")
          end
        end
        
        # Loads a given schema from a schema argument
        def load_schema(schema_argument, check = self.check_schemas)
          schema = case schema_argument
            when Symbol
              with_current_database do |database|
                case schema_argument
                  when :announced
                    database.announced_schema(true)
                  when :effective
                    database.effective_schema(true)
                  when :physical
                    database.physical_schema
                end
              end
            when String
              s = DbAgile::Core::Schema::yaml_file_load(schema_argument)
              s.schema_identifier = file
          end
          
          # A small check, to be sure
          if schema.nil?
            assumption_error!("Unexpected schema argument kind #{schema_argument}")
          end
              
          # Check schema if requested
          if check
            schema.check!
          end
          
          # Return schema now
          schema
        end
        
        # Yields the block, passing schemas as an array, according to 
        # kind_of_schema_arguments
        def with_schemas
          schemas = schema_arguments.collect{|arg| load_schema(arg)}
          case kind_of_schema_arguments
            when :single
              yield(schemas.first)
            when :double
              yield(schemas[0], schemas[1])
            when :multiple
              yield(schemas)
            else
              assumption_error!("Unexpected kind of schema argument #{kind_of_schema_arguments}")
          end
        end
        alias :with_schema :with_schemas
        
      end # module Commons
    end # module Schema
  end # class Command
end # module DbAgile