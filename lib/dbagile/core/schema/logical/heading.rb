module DbAgile
  module Core
    module Schema
      class Logical
        class Heading < Schema::Composite
         
          alias :attributes :parts
          
          # Yields the block with each attribute
          def each_attribute(&block)
            attributes.each(&block)
          end
        
        end # class Heading
      end # class Logical
    end # module Schema
  end # module Core
end # module DbAgile
