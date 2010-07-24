module DbAgile
  module Core
    class Schema
      class Logical < Schema::Brick
        class Constraints < Schema::Brick
          include Schema::NamedCollection
        
          # Creates a logical schema instance
          def initialize
            __initialize_named_collection
          end
        
          # @see DbAgile::Core::Schema::NamedCollection#brick_builder_handler
          def brick_builder_handler
            :constraints
          end
        
        end # class Constraints
      end # class Logical
    end # class Schema
  end # module Core
end # module DbAgile