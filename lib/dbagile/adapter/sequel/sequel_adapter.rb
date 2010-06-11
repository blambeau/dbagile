module DbAgile
  #
  # Implements Adapter::Contract using the Sequel gem.
  #
  class SequelAdapter < Adapter
    
    # Default options of this adapter
    DEFAULT_OPTIONS = {
      :trace_sql    => false,
      :trace_only   => false,
      :trace_buffer => nil
    }
    
    # Underlying database URI
    attr_reader :uri
    
    # Connection options 
    attr_reader :options
    
    # Creates an adapter with a given uri
    def initialize(uri, options = {})
      require('sequel')
      @uri = uri
      @options = DEFAULT_OPTIONS.merge(options)
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
      if @db.nil?
        @db = Sequel.connect(uri)
        if options[:trace_sql]
          # puts "Creating a logger with #{options[:trace_buffer].inspect}"
          @db.logger = SequelLogger.new(options[:trace_buffer]) 
        end
      end
      @db
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
      db.create_table(name) do 
        columns.each_pair{|name, type| column name, type}
      end
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
      db.add_index(table_name, columns, :unique => true)
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