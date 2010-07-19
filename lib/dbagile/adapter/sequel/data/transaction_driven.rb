module DbAgile
  class SequelAdapter < Adapter
    module Data
      module TransactionDriven

        # @see DbAgile::Contract::Data::TransactionDriven#insert
        def insert(transaction, table, tuple)
          has_table!(table)
          db[table].insert(tuple)
          tuple
        end
    
        # @see DbAgile::Contract::Data::TransactionDriven#update
        def update(transaction, table_name, update, proj = {})
          has_table!(table_name)
          if proj.nil? or proj.empty?
            db[table_name].update(update)
          else
            db[table_name].where(proj).update(update)
          end 
        end
    
        # @see DbAgile::Contract::Data::TransactionDriven#delete
        def delete(transaction, table_name, proj = {})
          has_table!(table_name)
          if proj.empty?
            db[table_name].delete
          else
            db[table_name].where(proj).delete
          end
          true
        end
      
        # @see DbAgile::Contract::Data::TransactionDriven#direct_sql
        def direct_sql(transaction, sql)
          if /^\s*(select|SELECT)/ =~ sql
            dataset(sql)
          else
            db << sql
          end
        end

      end # module TransactionDriven
    end # module Data
  end # class SequelAdapter
end # module DbAgile
