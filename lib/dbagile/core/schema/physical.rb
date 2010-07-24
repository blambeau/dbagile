require 'dbagile/core/schema/physical/indexes'
require 'dbagile/core/schema/physical/index'
module DbAgile
  module Core
    class Schema
      class Physical < Schema::Brick
        include Schema::NamedCollection
        
        # Creates a logical schema instance
        def initialize
          __initialize_named_collection
          self[:indexes] = Physical::Indexes.new
        end
        
        # @see DbAgile::Core::Schema::NamedCollection#builder_handler_name
        def builder_handler_name
          :physical
        end
        
      end # class Logical
    end # class Schema
  end # module Core
end # module DbAgile