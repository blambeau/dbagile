module FlexiDB
  class Adapter
    #
    # Specification of all the methods FlexiDB needs to make its job.
    #
    module AbstractAdapter
      
      # Returns a Dataset object for a given table
      def dataset(table)
        raise NotImplementedError
      end
      
      # Returns true if a table exists, false otherwise
      def has_table?(name)
        raise NotImplementedError
      end
      
      # Creates a table with some attributes.
      def create_table(name, columns)
        raise NotImplementedError
      end
      
      # Returns the list of column names for a given table
      def column_names(table)
        raise NotImplementedError
      end
      
      # Returns true if a column exists, false otherwise
      def has_column?(table, column)
        has_table?(table) and column_names(table).include?(column)
      end
      
      # Creates a table with some attributes.
      def add_columns(table, columns)
        raise NotImplementedError
      end
      
      # Ensures that a table exists and that all columns are correctly
      # defined
      def ensure_table(table, columns)
        if has_table?(table) 
          known_columns = column_names(table)
          columns = columns.dup.delete_if{|k,v| known_columns.include?(k)}
          add_columns(table, columns) unless columns.empty?
        else
          create_table(table, columns)
        end
        true
      end
      
      # Inserts a tuple inside a given table
      def insert(table, tuple)
        raise NotImplementedError
      end
      
      # Send SQL directly to the database SQL server
      def direct_sql(sql)
        raise NotImplementedError
      end

    end # module AbstractAdapter
  end # class Adapter
end # module FlexiDB