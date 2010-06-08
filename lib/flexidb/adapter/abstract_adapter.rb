module FlexiDB
  class Adapter
    #
    # Specification of all the methods FlexiDB needs to make its job.
    #
    module AbstractAdapter
      
      # Returns true if a table exists, false otherwise
      def has_table?(name)
        raise NotImplementedError
      end
      
      # Creates a table with some attributes.
      def create_table(name, columns)
        raise NotImplementedError
      end
      
      # Returns true if a column exists, false otherwise
      def has_column?(table, column)
        raise NotImplementedError
      end
      
      # Creates a table with some attributes.
      def add_columns(table, columns)
        raise NotImplementedError
      end
      
    end # module AbstractAdapter
  end # class Adapter
end # module FlexiDB