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
    
    # Build delegates from a set of arguments
    def build_delegates(*args)
      delegates = []
      until args.empty?
        case args[0]
          when ::DbAgile::Plugin
            delegates << args.shift
          when Module
            mod = args.shift
            mod_args = []
            until args.empty? or args[0].kind_of?(Module) or args[0].kind_of?(::DbAgile::Plugin)
              mod_args << args.shift
            end
            delegates << mod.new(nil, *mod_args)
        end
      end
      delegates
    end
    
    # Adds a brick inside the global chain
    def unshift_main_delegate(*args)
      build_delegates(*args).each{|newone|
        delegate.unshift_delegate(newone)
      }
    end
    
    # Unshifts a table delegate
    def unshift_table_delegate(table, *args)
      # 1) Force a chain delegate on main chain if no chain for that table
      @table_chains[table] = DbAgile::Adapter::DelegateChain.new(delegate)\
        unless @table_chains.key?(table)

      # 2) Install the newone now
      build_delegates(*args).each{|newone|
        @table_chains[table].unshift_delegate(newone)
      }
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