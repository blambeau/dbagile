module FlexiDB
  class FlexibleDSL
    
    # The database access point 
    attr_reader :db
    
    # Creates a DSL instance
    def initialize(db)
      @db = db
    end
    
    # Lookup for chain elements ...
    def self.const_missing(name)
      if ::FlexiDB::Chain::const_defined?(name)
        ::FlexiDB::Chain::const_get(name)
      else
        super
      end
    end
    
    # Adds a brick in the main chain
    def use(clazz, options = {})
      db.__insert_in_main_chain(clazz, options)
    end
    
    # Ensure that all tables are flexible 
    def flexible_tables(options = {})
      use(::FlexiDB::Chain::FlexibleTable, options)
    end
      
    private :db
  end # class FlexibleDSL
end # module FlexiDB