module DbAgile
  class SequelAdapter < Adapter
    module Schema
      module TableDriven

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

        # @see DbAgile::Contract::Schema::TableDriven#has_table?
        def has_table?(name)
          db.table_exists?(name)
        end
    
        # @see DbAgile::Contract::Schema::TableDriven#heading
        def heading(table_name)
          heading = {}
          db.schema(table_name).each do |pair|
            column_name, info = pair
            heading[column_name] = dbtype_to_ruby_type(info)
          end
          heading
        end
    
        # @see DbAgile::Contract::Schema::TableDriven#columns_names
        def column_names(table, sort_it_by_name = false)
          sort_it_by_name ? db[table].columns.sort{|k1,k2| k1.to_s <=> k2.to_s} : db[table].columns
        end
    
        # @see DbAgile::Contract::Schema::TableDriven#keys
        def keys(table_name)
          # take the indexes
          indexes = db.indexes(table_name).values
          indexes = indexes.select{|i| i[:unique] == true}.collect{|i| i[:columns]}.sort{|a1, a2| a1.size <=> a2.size}

          # take single keys as well
          key = db.schema(table_name).select{|pair|
            pair[1][:primary_key]
          }.collect{|pair| pair[0]}

          key.empty? ? indexes : (indexes + [ key ])
        end
    
      end # module TableDriven
    end # module Schema
  end # class SequelAdapter
end # module DbAgile
