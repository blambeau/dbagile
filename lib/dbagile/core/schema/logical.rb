require 'dbagile/core/schema/logical/relvar'
require 'dbagile/core/schema/logical/heading'
require 'dbagile/core/schema/logical/attribute'
require 'dbagile/core/schema/logical/constraints'
require 'dbagile/core/schema/logical/constraint'
module DbAgile
  module Core
    class Schema
      class Logical < Schema::Brick
        include Schema::NamedCollection
        
        # Creates a logical schema instance
        def initialize
          __initialize_named_collection
        end
        
        # @see DbAgile::Core::Schema::NamedCollection#brick_builder_handler
        def brick_builder_handler
          :logical
        end
        
      end # class Logical
    end # class Schema
  end # module Core
end # module DbAgile