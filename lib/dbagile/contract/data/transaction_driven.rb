module DbAgile
  module Contract
    module Data
      #
      # Transaction driven methods of the contract
      #
      module TransactionDriven
      
        #
        # Inserts a tuple inside a given table
        #
        # @param [Transaction] transaction the current transaction
        # @param [Symbol] table_name the name of a table
        # @param [Hash] record a record as a hash (column_name -> value)
        # @return [Hash] inserted record as a hash
        #
        # @pre [table_name] the table must exist
        # @pre [record] the record is valid for the table
        # @post the record has been inserted.
        #
        def insert(transaction, table_name, record)
          Kernel.raise NotImplementedError
        end
      
        #
        # Updates all tuples whose projection equal _proj_ with values given by _update_ 
        # inside a given table
        #
        # @param [Transaction] transaction the current transaction
        # @param [Symbol] table_name the name of a table
        # @param [Hash] proj a projection tuple
        # @return [Hash] update the new values for tuples
        #
        # @pre [table_name] the table must exist
        # @pre [update] the record is valid for the table
        # @pre [proj] the projection tuple is valid for the table
        # @post all records have been updated.
        #
        def update(transaction, table_name, update, proj = {})
          Kernel.raise NotImplementedError
        end
      
        #
        # Delete all tuples whose projection equal _proj_ inside a given table
        #
        # @param [Transaction] transaction the current transaction
        # @param [Symbol] table_name the name of a table
        # @param [Hash] proj a projection tuple
        #
        # @pre [table_name] the table must exist
        # @pre [proj] the projection tuple is valid for the table
        # @post all records have been updated.
        #
        def delete(transaction, table_name, proj = {})
          Kernel.raise NotImplementedError
        end
      
        #
        # Send SQL directly to the database SQL server.
        #
        # Returned result is left opened to adapters.
        #
        # @param [Transaction] transaction the current transaction
        # @param [String] sql a SQL query
        # @return [...] adapter defined
        #
        def direct_sql(transaction, sql)
          Kernel.raise NotImplementedError
        end

      end # module TransactionDriven
    end # module Data
  end # module Contract
end # module DbAgile
