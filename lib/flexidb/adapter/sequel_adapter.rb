module FlexiDB
  #
  # Implements the Adapter contract using Sequel gem.
  #
  class SequelAdapter < Adapter
    
    # Underlying database URI
    attr_reader :uri
    
    # Creates an adapter with a given uri
    def initialize(uri)
      require('sequel')
      @uri = uri
    end
    
    # Returns the underlying Sequel::Database instance
    def db
      @db ||= Sequel.connect(uri)
    end
    
    # Returns true if a table exists, false otherwise
    def has_table?(name)
      db.tables.include?(name)
    end
    
    # Creates a table with some attributes.
    def create_table(name, columns)
      raise NotImplementedError
    end
    
    # Returns the list of column names for a given table
    def column_names(table)
      raise ArgumentError, "No such table #{table}" unless has_table?(table)
      db[table].columns
    end
    
    # Creates a table with some attributes.
    def add_columns(table, columns)
      raise NotImplementedError
    end

  end # class SequelAdapter
end # module FlexiDB