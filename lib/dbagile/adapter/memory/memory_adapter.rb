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
    
    ### ABOUT CONNECTIONS ########################################################
      
    # Pings the server
    def ping
      true
    end
      
    # Disconnect the adapter and frees all resources.
    def disconnect
      tables = {}
      true
    end
    
    # Transaction
    def transaction
      yield(self)
    end
    
    ### ABOUT QUERIES ############################################################
      
    # Returns a Dataset object for a given table
    def dataset(table, proj = nil)
      raise ArgumentError, "No such table #{table}" unless has_table?(table)
      if proj.nil?
        tables[table]
      else
        keys = proj.keys
        tables[table].select{|t| tuple_project(t, keys) == proj}
      end
    end
    
    # Checks if a (sub)-tuple exists inside a table.
    def exists?(table_name, subtuple = {})
      if subtuple.empty?
        tables[table_name].count != 0
      else
        heading = subtuple.keys
        !tables[table_name].find{|t| tuple_project(t, heading) == subtuple}.nil?
      end
    end
      
    ### SCHEMA QUERIES ###########################################################
      
    # Returns true if a table exists, false otherwise
    def has_table?(name)
      tables.key?(name)
    end

    # Returns available keys for a given table as an array of column 
    # names.
    def keys(table_name)
      tables[table_name].keys.sort{|a1, a2| a1.size <=> a2.size}
    end

    # Returns the list of column names for a given table
    def column_names(table, sort = false)
      raise ArgumentError, "No such table #{table}" unless has_table?(table)
      tables[table].column_names(sort)
    end
    
    ### SCHEMA UPDATES ###########################################################
      
    # Creates a table with some attributes.
    def create_table(transaction, name, columns)
      raise ArgumentError, "Table #{name} already exists" if has_table?(name)
      tables[name] = Table.new(columns)
    end
    
    # Returns false
    def key!(transaction, table_name, columns)
      raise ArgumentError, "No such table #{table}" unless has_table?(table_name)
      tables[table_name].add_key(columns)
    end
    
    # Creates a table with some attributes.
    def add_columns(transaction, table, columns)
      raise ArgumentError, "No such table #{table}" unless has_table?(table)
      tables[table].add_columns(columns)
    end
    
    # Inserts a tuple inside a given table
    def insert(transaction, table, tuple)
      raise ArgumentError, "No such table #{table}" unless has_table?(table)
      tables[table].insert(tuple)
    end
    
    # Updates all tuples whose projection equal _proj_ with values given by _update_ 
    # inside a given table
    def update(transaction, table_name, proj, update)
      heading = proj.keys
      tables[table_name].tuples.each{|t|
        t.merge!(update) if tuple_project(t, heading) == proj
      }
      true
    end
      
    # Deletes all tuples whose projection equal _proj_ inside a given table
    def delete(transaction, table_name, proj)
      if proj.empty?
        tables[table_name].truncate!
      else
        heading = proj.keys
        tables[table_name].tuples.reject!{|t|
          tuple_project(t, heading) == proj
        }
      end
      true
    end

  end # class SequelAdapter
end # module DbAgile