module DbAgile
  class SequelAdapter < Adapter
    module Schema
      # 
      # Expands the schema of the underlying database
      #
      class Expander
      
        # Schema to add
        attr_reader :schema
      
        # Options
        attr_reader :options
      
        # Creates an Expander instance
        def initialize(schema, options)
          @schema, @options = schema, options
        end
      
        # Starts creating the schema on a sequel database object
        def run(conn)
          # Build the SQL script
          buffer = []
          schema.each_relvar{|relvar| expand_relvar(conn, relvar, buffer) }
          schema.each_relvar{|relvar| expand_relvar_foreign_keys(conn, relvar, buffer) }
          script = buffer.select{|k| !k.empty?}.join(";\n")
          
          # Execute
          if options[:dry_run]
            display(script)
            script
          else
            conn.execute_ddl(script)
          end
        rescue Sequel::Error => ex
          puts ex.message
          puts ex.backtrace.join("\n")
          raise
        end
        
        # Creates a relation variable
        def expand_relvar(conn, relvar, buffer)
          if conn.table_exists?(relvar.name)
            alter_relvar_table(conn, relvar, buffer)
          else
            create_relvar_table(conn, relvar, buffer)
          end
        end
        
        # Creates a relvar from scratch
        def create_relvar_table(conn, relvar, buffer)
          gen = Sequel::Schema::Generator.new(conn)
          relvar.each_attribute{|attribute|
            options = {:null => !attribute.mandatory?}
            case attribute.default_value
              when :autonumber
                options[:auto_increment] = true
              else
                options[:default] = attribute.default_value
            end
            gen.column(attribute.name, attribute.domain, options)
          }
          gen.primary_key(relvar.primary_key.attributes)
          sql = conn.send(:create_table_sql, relvar.name, gen, {})
          buffer << sql
        end
        
        def alter_relvar_table(conn, relvar, buffer)
        end
        
        # Creates the relvar foreign keys
        def expand_relvar_foreign_keys(conn, relvar, buffer)
          gen = Sequel::Schema::AlterTableGenerator.new(conn)
          relvar.each_foreign_key{|fk|
            gen.send(:add_composite_foreign_key, fk.source_attributes, fk.referenced, {:key => fk.target_attributes})
          }
          sql = conn.send(:alter_table_sql_list, relvar.name, gen.operations).flatten.join("\n")
          buffer << sql
        rescue Sequel::Error => ex
          handle_error("Skipping foreign keys... probably not supported (#{ex.message})", ex)
        end
        
        # Displays something
        def say(something, color)
          if env = options[:environment]
            env.say(something, color)
          end
        end
        
        # Displays something
        def display(something)
          if env = options[:environment]
            env.display(something)
          end
        end
        
        # Handles an error
        def handle_error(message, ex)
          if options[:friendly]
            say(message, :magenta)
          else
            raise ex
          end
        end
      
      end # class Expander
    end # module Schema
  end # module Core
end # module DbAgile
      
