require 'dbagile/core/schema/physical/indexes'
require 'dbagile/core/schema/physical/index'
module DbAgile
  module Core
    class Schema < SchemaObject::Composite
      class Physical < SchemaObject::Composite
        
        # Creates a logical schema instance
        def initialize
          super(:indexes => Physical::Indexes.new)
        end
                
      end # class Logical
    end # class Schema
  end # module Core
end # module DbAgile