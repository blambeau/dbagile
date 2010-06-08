module FlexiDB
  class FakeAdapter
    
    def adapter
      self
    end
    
    def with_global_lock
      yield(self)
    end
    
    # All other method calls 
    def calls
      @calls ||= []  
    end
    
    # Trace the method call
    def method_missing(name, *args, &block)
      calls << [name, args]
    end
    
  end # class FakeAdapter
end # module FlexiDB