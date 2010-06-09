module FlexiDB
  class Database
    include FlexiDB::Adapter::Delegate
    
    # Underlying adapter
    attr_reader :adapter
    
    # Creates a database instance with an underlying adapter
    def initialize(adapter)
      @adapter = adapter
    end
    
    # Disconnect from the database
    def disconnect
      adapter.disconnect
    end
    
    # Adds a brick inside the global chain
    def __insert_in_main_chain(clazz, *args)
      @adapter = clazz.new(@adapter, *args)
    end
    
    # Returns the adapter as delegate
    def delegate
      adapter
    end
    
  end # class Database
end # module FlexiDB