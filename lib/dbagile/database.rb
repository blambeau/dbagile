module DbAgile
  class Database
    
    # About creation ###############################################################
    
    # Creates a database instance with an underlying adapter
    def initialize(adapter)
      @delegate = DbAgile::Utils::Chain[adapter]
      @table_chains = {}
      unshift_table_delegate(:dbagile_sequences, 
        Plugin::AgileKeys[:candidate => /[#]$/],
        Plugin::AgileTable)
    end
    
    # About connections ############################################################
    
    # Disconnect from the database
    def disconnect
      main_delegate.disconnect
    end
    
    # About delegate chains ########################################################
    
    # Returns the main delegate
    def main_delegate
      @delegate
    end
    alias :adapter :main_delegate
    
    # Finds the delegate to use for a given table
    def find_delegate(table_name)
      @table_chains[table_name] || main_delegate
    end
    
    # Adds a brick inside the global chain
    def unshift_main_delegate(*args)
      main_delegate.plug(*args)
    end
    
    # Unshifts a table delegate
    def unshift_table_delegate(table, *args)
      # 1) Force a chain delegate on main chain if no chain for that table
      @table_chains[table] = DbAgile::Utils::Chain[main_delegate]\
        unless @table_chains.key?(table)

      # 2) Install the newone now
      @table_chains[table].plug(*args)
    end
    
    ### ABOUT QUERIES ##############################################################
    
    # @see Database#dataset
    def dataset(table_or_query, proj = nil)
      find_delegate(table_or_query).dataset(table_or_query, proj)
    end
    
    # @see Database#exists?
    def exists?(table_or_query, subtuple = {})
      find_delegate(table_or_query).exists?(table_or_query, subtuple)
    end
    
    ### SCHEMA QUERIES #############################################################
    
    # @see Database#has_table?
    def has_table?(table_name)
      find_delegate(table_name).has_table?(table_name)
    end
    
    # @see Database#has_column?
    def has_column?(table_name, column_name)
      find_delegate(table_name).has_column?(table_name, column_name)
    end
    
    # @see Database#column_names(table_name, sort)
    def column_names(table_name, sort = false)
      find_delegate(table_name).column_names(table_name, sort)
    end
    
    # @see Database#keys
    def keys(table_name)
      find_delegate(table_name).keys(table_name)
    end
    
    ### TRANSACTIONS AND WRITE ACCESSES ############################################
    
    # Starts a transaction. If a block is provided, yields it with the transaction 
    # object, commits the transaction at the end and returns nil. Otherwise, returns
    # the transaction object.
    def transaction
      t = Transaction.new(self)
      if block_given?
        begin
          yield(t)
          t.commit
        rescue Exception
          t.rollback
        end
      else
        t
      end
    end
    
    # Starts an engine instance on this database and 
    # executes the given block.
    def execute(source = nil, &block)
      engine = DbAgile::Engine.new(DbAgile::Engine::DslEnvironment.new(source || block))
      engine.connect(self)
      engine.execute
      self
    end
    
  end # class Database
end # module DbAgile