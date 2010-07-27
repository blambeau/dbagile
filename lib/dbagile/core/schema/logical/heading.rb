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
          
          # Checks if this heading has some attributes (through 
          # names)
          def has_attributes?(names)
            parts = composite_parts
            names.all?{|k| parts.key?(k)}
          end
          
          # Returns the domain of a specific attribute
          def domain_of(attr_name)
            attribute = self[attr_name]
            attribute ? attribute.domain : nil
          end
        
          ############################################################################
          ### Private interface
          ############################################################################
          
          # @see DbAgile::Core::Schema
          def _semantics_check(clazz, buffer)
            if empty?
              buffer.add_error(self, clazz::UnsupportedEmptyHeading)
            end
            super(clazz, buffer)
          end
          
        end # class Heading
      end # class Logical
    end # module Schema
  end # module Core
end # module DbAgile
