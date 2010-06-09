module FlexiDB
  class Adapter
    #
    # Specification of all the methods FlexiDB needs to make its job.
    #
    module Contract
      
      # Acquires a lock on the schema and yield the block with the adapter
      # as first argument. The default implementation simply yields the 
      # block.
      def with_schema_lock
        yield(self)
      end
      
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
      
      # Inserts a tuple inside a given table
      def insert(table, tuple)
        raise NotImplementedError
      end
      
      # Send SQL directly to the database SQL server
      def direct_sql(sql)
        raise NotImplementedError
      end

    end # module AbstractContract
  end # class Adapter
end # module FlexiDB