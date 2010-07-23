module DbAgile
  class SequelAdapter < Adapter
    module Schema
      # 
      # Loads a schema from an existing database through Sequel
      #
      class Loader
      
        # Returns the ruby type associated to a given column info
        def dbtype_to_ruby_type(info)
          type = info[:type]
          capitalized = type.to_s.capitalize
          begin
            Kernel.eval(capitalized)
          rescue NameError
            case type
              when :datetime
                Time
              when :boolean
                SByC::TypeSystem::Ruby::Boolean
              else
                Object
            end
          end
        end

        # Runs the loading process and returns the schema instance
        def run(conn)
          builder = DbAgile::Core::Schema::Builder.new
          builder.logical{ load_logical_schema(conn, builder) }
          builder.physical{ load_physical_schema(conn, builder) }
          builder._dump
        end
      
        def load_logical_schema(conn, builder)
          conn.tables.each{|table|
            load_table_schema(conn, builder, table)
          }
        end
      
        # Loads a table schema
        def load_table_schema(conn, builder, table)
          builder.relvar(table){
            primary_key_columns = load_table_heading(conn, builder, table)
            load_table_constraints(conn, builder, table, primary_key_columns)
          }
        end
        
        # Loads a table heading. Returns primary key columns
        def load_table_heading(conn, builder, table)
          primary_key_columns = []
          builder.heading{
            columns = conn.schema(table, {:reload => true})
            columns.each do |name, info|
              #puts info.inspect
              
              # find attribute definition
              defn = {:domain    => dbtype_to_ruby_type(info),
                      :mandatory => !info[:allow_null] }
              unless info[:ruby_default].nil?
                defn[:default] = info[:ruby_default]
              end
              
              # mark primary key columns
              if primary_key_columns and info[:primary_key]
                primary_key_columns << name 
              end
              
              # build the attribute
              builder.attribute(name, defn)
            end
          }
          primary_key_columns
        end
        
        # Loads table constraint
        def load_table_constraints(conn, builder, table, primary_key_columns = nil)
          builder.constraints{
            unless primary_key_columns.nil? or primary_key_columns.empty?
              builder.constraint(:pk, {:type => :primary_key, :attributes => primary_key_columns})
            end
            conn.indexes(table).each_pair{|name, defn|
              next unless defn[:unique]
              builder.constraint(name, {:type => :candidate_key, :attributes => defn[:columns]})
            }
          }
        end
      
        # Loads the physical schema
        def load_physical_schema(conn, builder)
          conn.tables.each{|table|
            conn.indexes(table).each_pair{|name, defn|
              next if defn[:unique]
              builder.index(name, {:type => :candidate_key, :attributes => defn[:columns]})
            }
          }
        end
      
      end # class Loader
    end # module Schema
  end # module Core
end # module DbAgile
