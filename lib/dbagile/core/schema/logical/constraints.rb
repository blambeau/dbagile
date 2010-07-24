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
        
        end # class Constraints
      end # class Logical
    end # class Schema
  end # module Core
end # module DbAgile