module DbAgile
  module Core
    class Schema
      module Physical
        class Index
        
          # Index name
          attr_reader :name
        
          # Index definition
          attr_reader :definition
        
          # Creates an index instance
          def initialize(name, definition)
            @name = name
            @definition = definition
          end
        
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
        
          # Compares with another index
          def ==(other)
            return nil unless other.kind_of?(Index)
            (name == other.name) and (definition == other.definition)
          end
        
        end # class Index
      end # module Physical
    end # class Schema
  end # module Core
end # module DbAgile
