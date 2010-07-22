module DbAgile
  module Core
    class Schema
      module Logical
        class Attribute
        
          # Attribute name
          attr_reader :name
        
          # Attribute definition
          attr_reader :definition
        
          # Creates a heading instance
          def initialize(name, definition)
            @name = name
            @definition = definition
          end
        
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
