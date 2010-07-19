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
      
    end # module Assumptions
  end # module Fixtures
end # module DbAgile