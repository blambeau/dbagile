module DbAgile
  module Core
    module Schema
      class Logical
        class Heading < Schema::Composite
         
          alias :attributes     :parts
          alias :each_attribute :each
        
        end # class Heading
      end # class Logical
    end # module Schema
  end # module Core
end # module DbAgile
