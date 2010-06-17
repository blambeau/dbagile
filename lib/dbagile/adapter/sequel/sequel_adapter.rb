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
        super(uri, options)
      end
    end  
    
    # Underlying database URI
    attr_reader :uri
    
    # Creates an adapter with a given uri
    def initialize(uri, options = {})
      require('sequel')
      @uri, @options = uri, options
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
    
    # Yields the block inside a transaction
    def transaction(&block)
      raise ArgumentError, "Missing transaction block" unless block
      db.transaction(&block)
    end
      
    # Returns the underlying Sequel::Database instance
    def db
      unless @db
        @db = Sequel.connect(uri)
        @db.logger = @options[:sequel_logger]
      end
      @db
    end
    
    ### ABOUT QUERIES ############################################################
      
    # Returns a Dataset object for a given table
    def dataset(table, proj = nil)
      case table
        when Symbol
          raise ArgumentError, "No such table #{table}" unless has_table?(table)
          proj.nil? ? db[table] : db[table].where(proj)
        else
          proj.nil? ? db[table] : db[table].where(proj)
      end
    end
      
    # Checks if a (sub)-tuple exists inside a table.
    def exists?(table_or_query, subtuple = {})
      if subtuple.nil? or subtuple.empty?
        !dataset(table_or_query).empty?
      else
        !dataset(table_or_query).where(subtuple).empty?
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
    
    # Returns keys of a table
    def keys(table_name)
      db.indexes(table_name).values.select{|i| i[:unique] == true}.collect{|i| i[:columns]}.sort{|a1, a2| a1.size <=> a2.size}
    end
    
    ### SCHEMA UPDATES ###########################################################
      
    # Creates a table with some attributes
    def create_table(transaction, name, columns)
      db.create_table(name){ 
        columns.each_pair{|name, type| column(name, type)} 
      }
      true
    end
    
    # Adds some columns to a table
    def add_columns(transaction, table, columns)
      db.alter_table(table) do
        columns.each_pair{|name, type| add_column name, type}
      end
      true
    end

    # 
    # Make columns be a candidate key for the table.
    #
    def key!(transaction, table_name, columns)
      db.add_index(table_name, columns, {:unique => true})
    end
      
    ### DATA UPDATES #############################################################
      
    # Inserts a tuple inside a given table
    def insert(transaction, table, tuple)
      db[table].insert(tuple)
      tuple
    end
    
    # Updates all tuples whose projection equal _proj_ with values given by _update_ 
    # inside a given table
    def update(transaction, table_name, proj, update)
      db[table_name].where(proj).update(update)
    end
    
    # Deletes all tuples whose projection equal _proj_ inside a given table
    def delete(transaction, table_name, proj)
      if proj.empty?
        db[table_name].delete
      else
        db[table_name].where(proj).delete
      end
      true
    end
      
    # Send SQL directly to the database SQL server
    def direct_sql(transaction, sql)
      if /^\s*(select|SELECT)/ =~ sql
        db[sql]
      else
        db << sql
      end
    end

  end # class SequelAdapter
end # module DbAgile