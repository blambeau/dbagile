require 'dbagile/core/schema/physical/indexes'
require 'dbagile/core/schema/physical/index'
module DbAgile
  module Core
    class Schema
      class Physical < Schema::Brick
        #
        # Index collection
        #
        class Indexes < Schema::Brick
          include Schema::NamedCollection
        
          # Creates a logical schema instance
          def initialize
            __initialize_named_collection
          end
        
          # @see DbAgile::Core::Schema::NamedCollection#brick_builder_handler
          def brick_builder_handler
            :indexes
          end
        
        end # class Indexes
      end # class Logical
    end # class Schema
  end # module Core
end # module DbAgile