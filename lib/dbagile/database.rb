module DbAgile
  class Database
    include DbAgile::Adapter::Delegate
    
    # Creates a database instance with an underlying adapter
    def initialize(delegate)
      @delegate = DbAgile::Adapter::DelegateChain.new(delegate)
      @table_chains = {}
    end
    
    # Disconnect from the database
    def disconnect
      delegate.disconnect
    end
    
    # Finds the delegate to use for a given table
    def find_delegate(table_name)
      @table_chains[table_name] || @delegate
    end
    
    # Adds a brick inside the global chain
    def unshift_main_delegate(clazz, *args)
      newone = clazz.new(delegate.delegate, *args)
      delegate.unshift_delegate(newone)
    end
    
    # Unshifts a table delegate
    def unshift_table_delegate(table, clazz, *args)
      # 1) Force a chain delegate on main chain if no chain for that table
      @table_chains[table] = DbAgile::Adapter::DelegateChain.new(delegate)\
        unless @table_chains.key?(table)

      # 2) Install the newone now
      newone = clazz.new(@table_chains[table].delegate, *args)
      @table_chains[table].unshift_delegate(newone)
    end
    
    # Starts an engine instance on this database and 
    # executes the given block.
    def execute(source = nil, &block)
      engine = DbAgile::Engine.new(DbAgile::Engine::DslEnvironment.new(source || block))
      engine.connect(self)
      engine.execute
      self
    end
    
    ### DATA UPDATES #############################################################
    
    # Inserts a tuple inside a given table
    def insert(table_name, record)
      find_delegate(table_name).insert(table_name, record)
    end
    
    # Updates all tuples whose projection equal _proj_ with values given by _update_ 
    # inside a given table
    def update(table_name, proj, update)
      find_delegate(table_name).update(table_name, proj, update)
    end
    
    # Delete all tuples whose projection equal _proj_ inside a given table
    def delete(table_name, proj)
      find_delegate(table_name).delete(table_name, proj)
    end
      
    alias :adapter :delegate
  end # class Database
end # module DbAgile