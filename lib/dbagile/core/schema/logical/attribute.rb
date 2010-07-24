module DbAgile
  module Core
    class Schema
      class Logical < Schema::Brick
        class Attribute < Schema::Brick
        
          # Attribute name
          attr_reader :name
        
          # Attribute definition
          attr_reader :definition
        
          # Creates a heading instance
          def initialize(name, definition)
            @name = name
            @definition = definition
          end
          
          # Returns attribute domain
          def domain
            definition[:domain]
          end
          
          # Returns default value
          def default_value
            definition[:default]
          end
        
          # Returns default value
          def mandatory?
            !(definition[:mandatory] == false)
          end
        
          ############################################################################
          ### DbAgile::Core::Schema::Brick
          ############################################################################
        
          # @see DbAgile::Core::Schema::Brick#brick_composite?
          def brick_composite?
            false
          end
        
          ############################################################################
          ### Equality and hash code
          ############################################################################
        
          # Compares with another attribute
          def ==(other)
            return nil unless other.kind_of?(Attribute)
            (name == other.name) and (definition == other.definition)
          end
        
          # Returns an hash code
          def hash
            [ name, definition ].hash
          end
          
          # Duplicates this attribute
          def dup
            Logical::Attribute.new(name, definition.dup)
          end
        
          ############################################################################
          ### About IO
          ############################################################################
        
          # Delegation pattern on YAML flushing
          def to_yaml(opts = {})
            YAML::quick_emit(self, opts){|out|
              defn = definition
              out.map("tag:yaml.org,2002:map", :inline ) do |map|
                map.add('domain', defn[:domain].to_s)
                map.add('mandatory', false) unless defn[:mandatory]
                if defn[:default]
                  map.add('default', defn[:default])
                end
              end
            }
          end
          
        end # class Attribute
      end # module Logical
    end # class Schema
  end # module Core
end # module DbAgile
