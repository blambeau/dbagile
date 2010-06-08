module FlexiDB
  class FakeAdapter
    
    def adapter
      self
    end
    
    def with_global_lock
      yield(self)
    end
    
    # All other method calls 
    def inserts
      @inserts ||= []  
    end
    
    # Trace the method call
    def insert(table, tuple)
      inserts << [table, tuple]
    end
    
  end # class FakeAdapter
end # module FlexiDB