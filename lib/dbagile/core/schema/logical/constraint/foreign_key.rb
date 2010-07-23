module DbAgile
  module Core
    class Schema
      module Logical
        class Constraint
          class ForeignKey < Constraint
          
            # Foreign key name
            attr_reader :name
          
            # Foreign key definition
            attr_reader :definition
          
            # Creates a key instance
            def initialize(name, definition)
              @name = name
              @definition = definition
            end
            
            # Returns source table attributes
            def source_attributes
              definition[:source]
            end
            
            # Returns the referenced table
            def referenced
              definition[:references]
            end
          
            # Returns target table attributes
            def target_attributes
              definition[:target]
            end
            
            # Delegation pattern on YAML flushing
            def to_yaml(opts = {})
              YAML::quick_emit(self, opts){|out|
                defn = definition
                source = Schema::Coercion::unsymbolize_array(definition[:source])
                target = Schema::Coercion::unsymbolize_array(definition[:target])
                out.map("tag:yaml.org,2002:map", :inline ) do |map|
                  map.add('type', definition[:type])
                  map.add('references', definition[:references].to_s)
                  map.add('source', source)
                  map.add('target', target)
                end
              }
            end

            # Compares with another attributes
            def ==(other)
              return nil unless other.kind_of?(ForeignKey)
              (name == other.name) and (definition == other.definition)
            end
          
          end # class ForeignKey
        end # class Constraint
      end # module Logical
    end # class Schema
  end # module Core
end # module DbAgile
