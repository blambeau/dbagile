module DbAgile
  module Contract
    module Schema
      #
      # Table-driven adapter read-only methods about schemas.
      #
      module TableDriven
        
        #
        # Returns true if a given table exists in the database, false otherwise.
        # 
        # @param [Symbol] table_name name of a table
        # @return true if the table exists, false otherwise
        #
        def has_table?(table_name)
          Kernel.raise NotImplementedError
        end
      
        #
        # Returns true if a column exists, false otherwise.
        #
        # A default implementation is provided that relies on column_names.
        #
        # @param [Symbol] table_name the name of a table
        # @param [Symbol] column_name the name of a column
        # @return true if the column exists on that table, false otherwise
        #
        # @pre the database contains a table with that name
        #
        def has_column?(table_name, column_name)
          column_names(table_name).include?(column_name)
        end
      
        #
        # Returns the list of column names for a given table.
        #
        # @param [Symbol] table_name the name of a table
        # @param [Boolean] sort sort column by names?
        # @return [Array<Symbol>] column names
        #
        # @pre the database contains a table with that name
        #
        def column_names(table_name, sort = false)
          Kernel.raise NotImplementedError
        end
      
        #
        # Checks if an array of column names for a key for a given table.
        #
        # @param [Symbol] table_name the name of a table
        # @param [Array<Symbol>] columns column names, in any order
        # @return [Boolean] true if the table contains such a unique key, 
        #         false otherwise
        #
        # @pre the database contains a table with that name
        #
        def is_key?(table_name, columns)
          keys(table_name).include?(columns)
        end
      
        #
        # Returns available keys for a given table as an array of column 
        # names.
        #
        # @param [Symbol] table_name the name of a table
        # @return [Array<Array<Symbol>>] keys of the table
        #
        def keys(table_name)
          Kernel.raise NotImplementedError
        end
      
      end # module TableDriven
    end # module Schema 
  end # module Contract
end # module DbAgile