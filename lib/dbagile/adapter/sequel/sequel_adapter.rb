module DbAgile
  #
  # Implements Adapter::Contract using the Sequel gem.
  #
  class SequelAdapter < Adapter
    
    ### CLASS... ###################################################################
    
    # Overrided to add a SequelTracer instance if trace is on  
    def self.new(uri, options = {})
      if options[:trace_sql]
        SequelTracer.new(super(uri), options)
      else
        super(uri)
      end
    end  
    
    # Underlying database URI
    attr_reader :uri
    
    # Creates an adapter with a given uri
    def initialize(uri)
      require('sequel')
      @uri = uri
    end
    
    ### ABOUT CONNECTIONS ########################################################
      
    # Pings the server
    def ping
      db.test_connection
    end
      
    # Disconnect the adapter and frees all resources.
    def disconnect
      @db.disconnect if @db
      true
    end
    
    # Returns the underlying Sequel::Database instance
    def db
      @db ||= Sequel.connect(uri)
    end
    
    ### ABOUT QUERIES ############################################################
      
    # Returns a Dataset object for a given table
    def dataset(table)
      case table
        when Symbol
          raise ArgumentError, "No such table #{table}" unless has_table?(table)
          db[table]
        else
          db[table]
      end
    end
      
    ### SCHEMA QUERIES ###########################################################
      
    # Returns true if a table exists, false otherwise
    def has_table?(name)
      db.table_exists?(name)
    end
    
    # Returns the list of column names for a given table
    def column_names(table, sort_it_by_name = false)
      sort_it_by_name ? db[table].columns.sort{|k1,k2| k1.to_s <=> k2.to_s} : db[table].columns
    end
    
    ### SCHEMA UPDATES ###########################################################
      
    # Creates a table with some attributes
    def create_table(name, columns)
      db.create_table(name){ 
        columns.each_pair{|name, type| column(name, type)} 
      }
      true
    end
    
    # Adds some columns to a table
    def add_columns(table, columns)
      db.alter_table(table) do
        columns.each_pair{|name, type| add_column name, type}
      end
      true
    end

    # 
    # Make columns be a candidate key for the table.
    #
    def key(table_name, columns)
      db.add_index(table_name, columns, {:unique => true})
    end
      
    ### DATA UPDATES #############################################################
      
    # Inserts a tuple inside a given table
    def insert(table, tuple)
      db[table].insert(tuple)
      tuple
    end
    
    # Send SQL directly to the database SQL server
    def direct_sql(sql)
      if /^\s*(select|SELECT)/ =~ sql
        db[sql]
      else
        db << sql
      end
    end

  end # class SequelAdapter
end # module DbAgile