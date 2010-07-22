module DbAgile
  module Core
    class Schema
      module Logical
        class Heading
        
          # Heading attributes
          attr_reader :attributes
        
          # Creates a heading instance
          def initialize(attributes = {})
            @attributes = attributes
          end
        
          # Returns an attribute definition
          def [](name)
            self.attributes[name]
          end
        
          # Sets an attribute definition
          def []=(name, definition)
            self.attributes[name] = definition
          end
        
          # Yields the block with each attribute 
          def each_attribute(&block)
            attributes.values.each(&block)
          end
          
          # Checks if this heading is empty
          def empty?
            attributes.empty?
          end
          
          # Minus pattern delegation
          def minus(other, builder)
            builder.heading{|b_attributes|
              mak, oak = self.attributes.keys, other.attributes.keys
              mine, common = (mak - oak), mak.select{|k| oak.include?(k)}
              mine.each{|m| b_attributes[m] = attributes[m]}
              common.each{|m| 
                unless attributes[m] == other.attributes[m]
                  b_attributes[m] = attributes[m]
                end
              }
            }
          end
          
          # Compares with another attribute
          def ==(other)
            return nil unless other.kind_of?(Heading)
            (attributes == other.attributes)
          end
        
          # Delegation pattern on YAML flushing
          def to_yaml(opts = {})
            Schema::Coercion::unsymbolize_hash(attributes).to_yaml(opts)
          end
        
        end # class Heading
      end # module Logical
    end # class Schema
  end # module Core
end # module DbAgile
