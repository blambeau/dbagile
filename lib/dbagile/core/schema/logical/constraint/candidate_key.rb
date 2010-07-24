module DbAgile
  module Core
    class Schema < SchemaObject::Composite
      class Logical < SchemaObject::Composite
        class Constraint < SchemaObject::Part
          class CandidateKey < Constraint
          
            # Is it a primary key?
            def primary?
              definition[:type] == :primary_key
            end
            
            # Returns key attributes
            def attributes
              definition[:attributes]
            end
          
            # Delegation pattern on YAML flushing
            def to_yaml(opts = {})
              YAML::quick_emit(self, opts){|out|
                defn = definition
                attrs = Schema::Coercion::unsymbolize_array(definition[:attributes])
                out.map("tag:yaml.org,2002:map", :inline ) do |map|
                  map.add('type', definition[:type])
                  map.add('attributes', attrs)
                end
              }
            end

          end # class CandidateKey
        end # class Constraint
      end # module Logical
    end # class Schema
  end # module Core
end # module DbAgile
