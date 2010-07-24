module DbAgile
  module Core
    class Schema
      class Physical < Schema::Brick
        class Index < Schema::Brick
        
          # Index name
          attr_reader :name
        
          # Index definition
          attr_reader :definition
        
          # Creates an index instance
          def initialize(name, definition)
            @name = name
            @definition = definition
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
        
          # Compares with another index
          def ==(other)
            return nil unless other.kind_of?(Index)
            (name == other.name) and (definition == other.definition)
          end
          
          # Returns an hash code
          def hash
            [ name, definition ].hash
          end
          
          # Duplicates this index
          def dup
            Physical::Index.new(name, definition.dup)
          end
        
          ############################################################################
          ### About IO
          ############################################################################
        
          # Delegation pattern on YAML flushing
          def to_yaml(opts = {})
            YAML::quick_emit(self, opts){|out|
              defn = definition
              attrs = Schema::Coercion::unsymbolize_array(definition[:attributes])
              out.map("tag:yaml.org,2002:map", :inline ) do |map|
                map.add('relvar', definition[:relvar].to_s)
                map.add('attributes', attrs)
              end
            }
          end
        
        end # class Index
      end # module Physical
    end # class Schema
  end # module Core
end # module DbAgile
