module DbAgile
  class SequelAdapter < Adapter
    module Schema
      module TransactionDriven

        # @see DbAgile::Contract::Schema::TransactionDriven#create_table
        def create_table(transaction, name, columns)
          db.create_table(name){ 
            columns.each_pair{|name, type| column(name, type)} 
          }
          columns
        end
    
        # @see DbAgile::Contract::Schema::TransactionDriven#drop_table
        def drop_table(transaction, table_name)
          db.drop_table(table_name)
          true
        end
        
        # @see DbAgile::Contract::Schema::TransactionDriven#add_columns
        def add_columns(transaction, table, columns)
          db.alter_table(table) do
            columns.each_pair{|name, type| add_column name, type}
          end
          true
        end

        # @see DbAgile::Contract::Schema::TransactionDriven#key!
        def key!(transaction, table_name, columns)
          db.add_index(table_name, columns, {:unique => true})
        end
      
      end # module TransactionDriven
    end # module Schema
  end # class SequelAdapter
end # module DbAgile
