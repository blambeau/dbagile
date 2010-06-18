module DbAgile
  module Contract
    #
    # Table driven methods of the contract
    #
    module TableDriven
      
      #
      # Returns a dataset object for a given table (if a Symbol is given) or query 
      # (if a String is given). 
      #
      # As DbAgile aims at helping to manage SQL database access with respect to their
      # schema, it does not specifies a detailed contract about the object returned here,
      # which is related to queries, not schema modification. The kind of returned object
      # is therefore left open to adapter specfic implementations.
      #
      # We expect (mainly for tests) the following about datasets:
      # - count: returns the number of records inside the dataset
      # - to_a: returns an array of hashes representing records
      #
      # @param [Symbol | String] table_or_query name of a table or query string
      # @param [Hash | nil] a tuple projection for query restriction
      # @return [...] a dataset object with query (execution result)
      #
      # @pre if table_or_query is a Symbol, that table exists in the database.
      #
      def dataset(table_or_query, proj = nil)
        Kernel.raise NotImplementedError
      end
      
      # 
      # Checks if a (sub)-tuple exists inside a table.
      #
      # @param [Symbol | String] table_or_query name of a table or query string
      # @param [Hash] subtuple a tuple or tuple projection for the result
      # @return true if the projection of the query result on subtuple's heading contains
      #         the subtuple itself, false otherwise.
      #
      # @pre if table_or_query is a Symbol, that table exists in the database.
      #
      def exists?(table_or_query, subtuple = {})
        Kernel.raise NotImplementedError
      end
      
      ### SCHEMA QUERIES ###########################################################
      
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
  end # module Contract
end # module DbAgile
