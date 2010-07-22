module DbAgile
  module Core
    class Schema
      module Logical
        class Constraint
          class CandidateKey < Constraint
          
            # Candidate key name
            attr_reader :name
          
            # Candidate key definition
            attr_reader :definition
          
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
