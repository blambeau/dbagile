module DbAgile
  module Core
    module Schema
      class Logical < Schema::Composite
        
        # Returns a relation variable by its name
        def relation_variable(name)
          self[name]
        end
        
        # Returns an array with part dependencies
        def dependencies(include_parent = false)
          []
        end
        
      end # class Logical
    end # module Schema
  end # module Core
end # module DbAgile
require 'dbagile/core/schema/logical/relvar'
require 'dbagile/core/schema/logical/relview'
require 'dbagile/core/schema/logical/heading'
require 'dbagile/core/schema/logical/attribute'
require 'dbagile/core/schema/logical/constraints'
require 'dbagile/core/schema/logical/constraint'
