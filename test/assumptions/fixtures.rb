require File.expand_path('../../spec_helper.rb', __FILE__)
module DbAgile
  module Fixtures
    module Assumptions

      module SafeModule
        
        def safe_method
          SafeModule
        end
        
      end
      
      class UnsafeClass
        
        def safe_method
          UnsafeClass
        end
        
        include SafeModule
      end
      
      class FooComparable
        
        attr_reader :int
        
        def initialize(int)
          @int = int
        end
        
        def <=>(other)
          @int <=> other.int
        end
        
      end
      
    end # module Assumptions
  end # module Fixtures
end # module DbAgile