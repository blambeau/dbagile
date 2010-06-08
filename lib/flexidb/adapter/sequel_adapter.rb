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
    
    # Returns a Dataset object for a given table
    def dataset(table)
      raise ArgumentError, "No such table #{table}" unless has_table?(table)
      db[table]
    end
      
    # Returns true if a table exists, false otherwise
    def has_table?(name)
      db.tables.include?(name)
    end
    
    # Creates a table with some attributes
    def create_table(name, columns)
      raise ArgumentError, "Table #{name} already exists" if has_table?(name)
      db.create_table(name) do 
        columns.each_pair{|name, type| column name, type}
      end
      true
    end
    
    # Returns the list of column names for a given table
    def column_names(table, sort_it_by_name = false)
      raise ArgumentError, "No such table #{table}" unless has_table?(table)
      sort_it_by_name ? db[table].columns.sort{|k1,k2| k1.to_s <=> k2.to_s} : db[table].columns
    end
    
    # Adds some columns to a table
    def add_columns(table, columns)
      raise ArgumentError, "No such table #{table}" unless has_table?(table)
      db.alter_table(table) do
        columns.each_pair{|name, type| add_column name, type}
      end
      true
    end

    # Inserts a tuple inside a given table
    def insert(table, tuple)
      db[table].insert(tuple)
      tuple
    end
    
    # Send SQL directly to the database SQL server
    def direct_sql(sql)
      db[sql]
    end

  end # class SequelAdapter
end # module FlexiDB