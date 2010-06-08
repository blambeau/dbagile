module FlexiDB
  class Database
    
    # Underlying adapter
    attr_reader :adapter
    
    # Creates a database instance with an underlying adapter
    def initialize(adapter)
      @adapter = adapter
      @schema_lock = Mutex.new
    end
    
    # Ensures that a lock has been acquired on the schema
    def with_schema_lock
      @schema_lock.synchronize{ yield(adapter) }
    end
    
    # Does a table exists?
    def table_exists?(table)
      adapter.has_table?(table)
    end

    # Returns the heading of a given tuple
    def heading_of(tuple)
      heading = {}
      tuple.each_pair{|name, value| heading[name] = value.class unless value.nil?}
      heading
    end
    
    # Inserts a tuple inside a given table
    def insert(table, tuple)
      # Ensure the schema first
      heading = heading_of(tuple)
      with_schema_lock{|adapter| adapter.ensure_table(table, heading) }
      adapter.insert(table, tuple)
    end
    
    # Returns the contents of a table
    def [](table)
      adapter.dataset(table)
    end
    
    # Send sql directly 
    def direct_sql(sql)
      adapter.direct_sql(sql)
    end
    
  end # class Database
end # module FlexiDB