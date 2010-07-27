module DbAgile
  class SequelAdapter < Adapter
    module Schema
      class TableCollapseHelper
        include Schema::Schema2SequelArgs
    
        # Relation variable instance
        attr_reader :master_relvar
    
        # Schema information
        attr_reader :schema_info
      
        # Sequel connection to use
        attr_reader :conn
      
        # Sequel generator wrapped 
        attr_reader :generator
      
        # Creates a CollapseHelper instance
        def initialize(relvar, schema_info, conn)
          @master_relvar, @schema_info, @conn = relvar, schema_info, conn
          @generator = Sequel::Schema::AlterTableGenerator.new(conn)
        end
  
        # Drop the whole relvar
        def relvar(relvar)
          @generator = nil
        end
  
        # Create/alter an attribute
        def attribute(attribute)
          generator.drop_column(attribute.name)
        end
    
        # Create/alter a candidate key
        def candidate_key(ckey)
          generator.drop_constraint(ckey.name)
        end
    
        # Create/alter a foreign key
        def foreign_key(fkey)
          generator.drop_constraint(fkey.name)
        end
    
        # Create/alter an index
        def index(index)
          attr_names = index.indexed_attributes.collect{|a| a.name}
          generator.drop_index(attr_names, {:name => index.name})
        end
    
        # Flushes SQL
        def flush(buffer)
          if generator.nil?
            buffer << conn.send(:drop_table_sql, master_relvar.name) << ";\n"
          else
            sql = conn.send(:alter_table_sql_list, master_relvar.name, generator.operations)
            sql = sql.flatten.join(";\n")
            buffer << sql << ";\n"
          end
        end
    
      end # TableExpandHelper
    end # module Schema
  end # class SequelAdapter
end # module DbAgile