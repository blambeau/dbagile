module DbAgile
  class SequelAdapter < Adapter
    module Schema
      module TableDriven

        # @see DbAgile::Contract::Schema::TableDriven#has_table?
        def has_table?(name)
          db.table_exists?(name)
        end
    
        # @see DbAgile::Contract::Schema::TableDriven#columns_names
        def column_names(table, sort_it_by_name = false)
          sort_it_by_name ? db[table].columns.sort{|k1,k2| k1.to_s <=> k2.to_s} : db[table].columns
        end
    
        # @see DbAgile::Contract::Schema::TableDriven#keys
        def keys(table_name)
          db.indexes(table_name).values.select{|i| i[:unique] == true}.collect{|i| i[:columns]}.sort{|a1, a2| a1.size <=> a2.size}
        end
    
      end # module TableDriven
    end # module Schema
  end # class SequelAdapter
end # module DbAgile
