module DbAgile
  module Contract
    module Schema
      module TransactionDriven

        #
        # Creates a table with some columns. 
        #
        # @param [Transaction] transaction the current transaction
        # @param [Symbol] table_name the name of a table
        # @param [Hash] a table heading
        # @return [Hash] the actual table heading that has been created
        #
        # @pre [table_name] the table must not exist
        #
        def create_table(transaction, table_name, columns)
          Kernel.raise NotImplementedError
        end
        
        #
        # Drops a table
        #
        # @param [Transaction] transaction the current transaction
        # @param [Symbol] table_name the name of a table
        # @return [Boolean] true to indicate that everything is fine
        #
        # @pre [table_name] the table must not exist
        #
        def drop_table(transaction, table_name)
          Kernel.raise NotImplementedError
        end
      
        #
        # Adds some columns to a table
        #
        # @param [Transaction] transaction the current transaction
        # @param [Symbol] table_name the name of a table
        # @param [Hash] columns column definitions
        # @return [Boolean] true to indicate that everything is fine
        #
        # @pre [table_name] the table must not exist
        # @pre [columns] the table may not contain any of the columns
        # @post the table has gained the additional columns
        #
        def add_columns(transaction, table_name, columns)
          Kernel.raise NotImplementedError
        end
      
        # 
        # Make columns be a candidate key for the table.
        #
        # @param [Transaction] transaction the current transaction
        # @param [Symbol] table_name the name of a table
        # @param [Array<Symbol>] columns column names
        # @return [Boolean] true to indicate that everything is fine
        #
        # @pre [table_name] the table must not exist
        # @pre [columns] the table must have all columns
        # @post the table has gained the candidate key
        #
        def key!(transaction, table_name, columns)
          Kernel.raise NotImplementedError
        end
      
      end # module TransactionDriven
    end # module Schema
  end # module Contract 
end # module DbAgile