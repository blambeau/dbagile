module DbAgile
  class SequelAdapter < Adapter
    module Schema
      class TableExpandHelper
        include Schema::Schema2SequelArgs
    
        # Relation variable instance
        attr_reader :relvar
    
        # Schema information
        attr_reader :schema_info
      
        # Sequel connection to use
        attr_reader :conn
      
        # Sequel generator wrapped 
        attr_reader :generator
      
        def initialize(relvar, schema_info, conn)
          @relvar, @schema_info, @conn = relvar, schema_info, conn
          if schema_info.relvar_exists?(relvar)
            @generator = Sequel::Schema::AlterTableGenerator.new(conn)
          else
            @generator = Sequel::Schema::Generator.new(conn)
          end
        end
  
        # Is it a CREATE TABLE helper?  
        def create?
          generator.kind_of?(Sequel::Schema::Generator)
        end
  
        # Create/alter an attribute
        def attribute(attribute)
          if create? 
            generator.column(*attribute2column_args(attribute)) 
          else 
            generator.add_column(*attribute2column_args(attribute))
          end
        end
    
        # Create/alter a candidate key
        def candidate_key(ckey)
          if ckey.primary?
            if create? 
              generator.primary_key(*candidate_key2primary_key_args(ckey)) 
            else 
              generator.add_primary_key(*candidate_key2primary_key_args(ckey))
            end
          else
            if create? 
              generator.unique(*candidate2unique_args(ckey)) 
            else 
              generator.add_unique_constraint(*candidate2unique_args(ckey))
            end
          end
        end
    
        # Create/alter a foreign key
        def foreign_key(fkey)
          if create?
            generator.foreign_key(*foreign_key2foreign_key_args(fkey))
          else
            generator.add_foreign_key(*foreign_key2foreign_key_args(fkey))
          end
        end
    
        # Create/alter an index
        def index(index)
          if create? 
            generator.index(*index2index_args(index)) 
          else 
            generator.add_index(*index2index_args(index))
          end
        end
    
        # Flushes SQL
        def flush(buffer)
          if create?
            sql = conn.send(:create_table_sql, relvar.name, generator, {})
            buffer << sql << ";\n"
            schema_info.relvar_exists!(relvar)
          else
            sql = conn.send(:alter_table_sql_list, relvar.name, generator.operations)
            sql = sql.flatten.join(";\n")
            buffer << sql << ";\n"
          end
        end
    
      end # TableExpandHelper
    end # module Schema
  end # class SequelAdapter
end # module DbAgile