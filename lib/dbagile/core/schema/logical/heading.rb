module DbAgile
  module Core
    class Schema
      class Logical < Schema::Brick
        class Heading < Schema::Brick
         
          # Attributes
          attr_reader :attributes
          protected :attributes
        
          # Creates a heading instance
          def initialize(attributes = {})
            @attributes = attributes
          end
        
          # Yields the block with each attribute 
          def each_attribute(&block)
            @attributes.values.each(&block)
          end
          
          ############################################################################
          ### Schema computations
          ############################################################################
          
          # Minus pattern delegation
          def minus(other, builder)
            builder.heading{|b_attributes|
              @attributes.keys.each{|name|
                my_attr, other_attr = @attributes[name], other[name]
                if other_attr.nil?
                  # missing in right
                  b_attributes[name] = @attributes[name]
                elsif my_attr == other_attr
                  # present in right, same
                else
                  # present in right, conflicting
                  b_attributes[name] = @attributes[name]
                end
              }
            }
          end
          
          ############################################################################
          ### DbAgile::Core::Schema::Brick
          ############################################################################
        
          # @see DbAgile::Core::Schema::Brick#brick_composite?
          def brick_composite?
            true
          end
        
          # @see DbAgile::Core::Schema::Brick#brick_empty?
          def brick_empty?
            @attributes.empty?
          end
          
          # @see DbAgile::Core::Schema::Brick#brick_subbrick_keys
          def brick_subbrick_keys
            @attributes.keys
          end 
        
          # @see DbAgile::Core::Schema::Brick#brick_children
          def brick_children
            @attributes.values
          end
        
          # Returns an attribute definition
          def [](name)
            @attributes[name]
          end
        
          # @see DbAgile::Core::Schema::Brick#[]=
          def []=(name, definition)
            @attributes[name] = definition
            definition.send(:parent=, self)
            definition
          end
          
          ############################################################################
          ### Equality and hash code
          ############################################################################
        
          # Compares with another attribute
          def ==(other)
            return nil unless other.kind_of?(Heading)
            (@attributes == other.attributes)
          end
        
          # Returns an hash code
          def hash
            @attributes.hash
          end
          
          # Duplicates this attribute
          def dup
            dup = Logical::Heading.new
            @attributes.each{|name, attribute|
              dup[name] = attribute.dup
            }
            dup
          end
        
          ############################################################################
          ### About IO
          ############################################################################
        
          # Delegation pattern on YAML flushing
          def to_yaml(opts = {})
            Schema::Coercion::unsymbolize_hash(@attributes).to_yaml(opts)
          end
        
        end # class Heading
      end # module Logical
    end # class Schema
  end # module Core
end # module DbAgile
