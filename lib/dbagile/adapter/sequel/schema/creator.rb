module DbAgile
  class SequelAdapter < Adapter
    module Schema
      # 
      # Creates a schema inside the database from a Schema instance
      #
      class Creator
      
        # Starts creating the schema
        def run(conn, schema)
          buffer = []
          schema.each_relvar{|relvar|
            create_relvar(conn, buffer, schema, relvar)
          }
          schema.each_relvar{|relvar|
            create_relvar_foreign_keys(conn, buffer, schema, relvar)
          }
          buffer.each{|s|
            puts s
          }
        end
        
        # Creates a relation variable
        def create_relvar(conn, buffer, schema, relvar)
          gen = Sequel::Schema::Generator.new(conn)
          relvar.each_attribute{|attribute|
            options = {:null => !attribute.mandatory?}
            if attribute.default_value
              options[:default] = attribute.default_value
            end
            gen.column(attribute.name, attribute.domain, options)
          }
          gen.primary_key(relvar.primary_key.attributes)
          sql = conn.send(:create_table_sql, relvar.name, gen, {})
          buffer << sql
        end
        
        # Creates the relvar foreign keys
        def create_relvar_foreign_keys(conn, buffer, schema, relvar)
          gen = Sequel::Schema::AlterTableGenerator.new(conn)
          relvar.each_foreign_key{|fk|
            gen.send(:add_composite_foreign_key, fk.source_attributes, fk.references, {:key => fk.target_attributes})
          }
          sql = conn.send(:alter_table_sql_list, relvar.name, gen.operations).flatten.join("\n")
          buffer << sql
        end
      
      end # class Loader
    end # module Schema
  end # module Core
end # module DbAgile
      
