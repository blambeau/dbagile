require 'dbagile/core/schema/physical/indexes'
require 'dbagile/core/schema/physical/index'
module DbAgile
  module Core
    class Schema < SchemaObject::Composite
      class Physical 
        class Indexes < SchemaObject::Composite
        end # class Indexes
      end # class Logical
    end # class Schema
  end # module Core
end # module DbAgile