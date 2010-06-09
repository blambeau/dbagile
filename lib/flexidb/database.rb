module FlexiDB
  class Database
    
    # Underlying adapter
    attr_reader :adapter
    
    # Creates a database instance with an underlying adapter
    def initialize(adapter)
      @adapter = adapter
    end
    
    # Adds a brick inside the global chain
    def __insert_in_main_chain(clazz, options)
      @adapter = clazz.new(@adapter, options)
    end
    
    # Returns the contents of a table
    def dataset(table)
      adapter.dataset(table)
    end
    
    # Send sql directly 
    def direct_sql(sql)
      adapter.direct_sql(sql)
    end
    
    # Inserts a tuple inside a given table
    def insert(table, tuple)
      adapter.insert(table, tuple)
    end
    
  end # class Database
end # module FlexiDB