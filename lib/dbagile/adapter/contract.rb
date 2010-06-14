module DbAgile
  class Adapter
    #
    # Specification of all adapter methods that DbAgile needs to make its job.
    #
    module Contract
      
      ### ABOUT CONNECTIONS ########################################################
      
      # 
      # Ping the SQL server, returns true if everything is fine. Raises an
      # error otherwise
      #
      # @return true
      #
      def ping
        Kernel.raise NotImplementedError
      end
      
      # 
      # Disconnect the adapter and frees all resources.
      #
      # @return true
      #
      def disconnect
        Kernel.raise NotImplementedError
      end
    
      ### ABOUT QUERIES ############################################################
      
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
      # @return [...] a dataset object with query (execution result)
      #
      # @pre if table_or_query is a Symbol, that table exists in the database.
      #
      def dataset(table_or_query)
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
      # Returns available keys for a given table as an array of column 
      # names.
      #
      # @param [Symbol] table_name the name of a table
      # @return [Array<Array<Symbol>>] keys of the table
      #
      def keys(table_name)
        Kernel.raise NotImplementedError
      end
      
      # #
      # # Returns a candidate key for a given table.
      # #
      # # The default implementation simply returns keys(table_name)[0].
      # #
      # def key(table_name)
      #   keys(table_name)[0]
      # end
      
      ### SCHEMA UPDATES ###########################################################
      
      #
      # Creates a table with some columns. 
      #
      # @param [Symbol] table_name the name of a table
      # @param [Hash] columns column definitions
      # @return [Boolean] true to indicate that everything is fine
      #
      # @pre the database does not contain a table with that name
      # @post the database contains a table with specified columns
      #
      def create_table(table_name, columns)
        Kernel.raise NotImplementedError
      end
      
      #
      # Adds some columns to a table
      #
      # @param [Symbol] table_name the name of a table
      # @param [Hash] columns column definitions
      # @return [Boolean] true to indicate that everything is fine
      #
      # @pre the database contains a table with that name
      # @pre the table does not contain any of the columns
      # @post the table has gained the additional columns
      #
      def add_columns(table_name, columns)
        Kernel.raise NotImplementedError
      end
      
      # 
      # Make columns be a candidate key for the table.
      #
      # @param [Symbol] table_name the name of a table
      # @param [Array<Symbol>] columns column names
      # @return [Boolean] true to indicate that everything is fine
      #
      # @pre the database contains a table with that name
      # @pre the table contains all the columns
      # @post the table has gained the candidate key
      #
      def key!(table_name, columns)
        Kernel.raise NotImplementedError
      end
      
      ### DATA UPDATES #############################################################
      
      #
      # Inserts a tuple inside a given table
      #
      # @param [Symbol] table_name the name of a table
      # @param [Hash] record a record as a hash (column_name -> value)
      # @return [Hash] inserted record as a hash
      #
      # @pre the database contains a table with that name
      # @pre the record is valid for the table
      # @post the record has been inserted.
      #
      def insert(table_name, record)
        Kernel.raise NotImplementedError
      end
      
      #
      # Send SQL directly to the database SQL server.
      #
      # Returned result is left opened to adapters.
      #
      # @param [String] sql a SQL query
      # @return [...] adapter defined
      #
      def direct_sql(sql)
        Kernel.raise NotImplementedError
      end

    end # module AbstractContract
  end # class Adapter
end # module DbAgile