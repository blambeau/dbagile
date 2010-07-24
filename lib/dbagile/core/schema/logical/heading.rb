module DbAgile
  module Core
    class Schema < SchemaObject::Composite
      class Logical < SchemaObject::Composite
        class Heading < SchemaObject::Composite
         
          alias :attributes     :parts
          alias :each_attribute :each
        
        end # class Heading
      end # class Logical
    end # class Schema
  end # module Core
end # module DbAgile
