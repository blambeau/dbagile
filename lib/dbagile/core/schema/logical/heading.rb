module DbAgile
  module Core
    class Schema
      class Logical < Schema::Brick
        class Heading < Schema::Brick
          include Schema::NamedCollection
         
          # Creates a heading instance
          def initialize(attributes = {})
            __initialize_named_collection(attributes)
          end
          
          alias :attributes :sub_bricks
          alias :each_attribute :each
        
        end # class Heading
      end # module Logical
    end # class Schema
  end # module Core
end # module DbAgile
