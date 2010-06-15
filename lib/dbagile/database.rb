module DbAgile
  class Database
    include DbAgile::Adapter::Delegate
    
    # Creates a database instance with an underlying adapter
    def initialize(delegate)
      @delegate = DelegateChain.new(delegate)
    end
    
    # Disconnect from the database
    def disconnect
      delegate.disconnect
    end
    
    # Adds a brick inside the global chain
    def unshift_delegate(clazz, *args)
      delegate.unshift_delegate(clazz.new(delegate, *args))
    end
    
    # Starts an engine instance on this database and 
    # executes the given block.
    def execute(source = nil, &block)
      engine = DbAgile::Engine.new(DbAgile::Engine::DslEnvironment.new(source || block))
      engine.connect(self)
      engine.execute
      self
    end
    
    alias :adapter :delegate
  end # class Database
end # module DbAgile