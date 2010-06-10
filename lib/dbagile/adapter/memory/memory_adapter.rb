module DbAgile
  #
  # Implements the Adapter contract using memory tables.
  #
  class MemoryAdapter < Adapter
    
    # Table hash (name -> array of hash tuples)
    attr_reader :tables
    
    # Creates an adapter instance
    def initialize
      @tables = {}
    end
    
    # Pings the server
    def ping
      true
    end
      
    # Disconnect the adapter and frees all resources.
    def disconnect
      tables = {}
      true
    end
    
    # Returns a Dataset object for a given table
    def dataset(table)
      raise ArgumentError, "No such table #{table}" unless has_table?(table)
      tables[table]
    end
    
    # Returns true if a table exists, false otherwise
    def has_table?(name)
      tables.key?(name)
    end
    
    # Creates a table with some attributes.
    def create_table(name, columns)
      raise ArgumentError, "Table #{name} already exists" if has_table?(name)
      tables[name] = Table.new(columns)
    end
    
    # Returns false
    def key(table_name, columns)
      raise ArgumentError, "No such table #{table}" unless has_table?(table_name)
      tables[table_name].add_key(columns)
    end
    
    # Returns the list of column names for a given table
    def column_names(table, sort = false)
      raise ArgumentError, "No such table #{table}" unless has_table?(table)
      tables[table].column_names(sort)
    end
    
    # Creates a table with some attributes.
    def add_columns(table, columns)
      raise ArgumentError, "No such table #{table}" unless has_table?(table)
      tables[table].add_columns(columns)
    end
    
    # Inserts a tuple inside a given table
    def insert(table, tuple)
      raise ArgumentError, "No such table #{table}" unless has_table?(table)
      tables[table].insert(tuple)
    end
    
    # Send SQL directly to the database SQL server
    def direct_sql(sql)
      raise NotImplementedError
    end

  end # class SequelAdapter
end # module DbAgile