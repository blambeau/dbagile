module FlexiDB
  class FlexibleDSL
    
    # The database access point 
    attr_reader :db
    
    # Creates a DSL instance
    def initialize(db)
      @db = db
    end
    
    # Installs ruby extensions, yields the block, removes extensions
    def with_object_extension
      if RUBY_VERSION <= "1.9"
        old_method = Object.method(:const_missing)
        (class << Object; self; end).send(:define_method, :const_missing){|name|
          if ::FlexiDB::Plugin::const_defined?(name)
            ::FlexiDB::Plugin::const_get(name)
          else
            super
          end
        }
        result = yield
        (class << Object; self; end).send(:define_method, :const_missing, old_method)
        result
      else
        yield
      end
    end
    
    # Executes the block with this DSL
    def execute(&block)
      with_object_extension{self.instance_eval(&block)}
    end
    
    # Lookup for chain elements ...
    def self.const_missing(name)
      if ::FlexiDB::Plugin::const_defined?(name)
        ::FlexiDB::Plugin::const_get(name)
      else
        super
      end
    end
    
    # Adds a brick in the main chain
    def use(clazz, options = {})
      db.__insert_in_main_chain(clazz, options)
    end
      
    private :db, :execute
  end # class FlexibleDSL
end # module FlexiDB