require 'dbagile/core/schema/physical/indexes'
require 'dbagile/core/schema/physical/index'
module DbAgile
  module Core
    class Schema
      class Physical < Schema::Brick
        include Schema::NamedCollection
        
        # Sub brick keys
        BRICK_SUBBRICK_KEYS = [ :indexes ]
        
        # Creates a logical schema instance
        def initialize
          __initialize_named_collection
          self[:indexes] = Physical::Indexes.new
        end
                
        # @see DbAgile::Core::Schema::Brick#brick_subbrick_keys
        def brick_subbrick_keys
          BRICK_SUBBRICK_KEYS
        end 
          
      end # class Logical
    end # class Schema
  end # module Core
end # module DbAgile