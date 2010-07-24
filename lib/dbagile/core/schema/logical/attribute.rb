module DbAgile
  module Core
    class Schema < SchemaObject::Composite
      class Logical < SchemaObject::Composite
        class Attribute < SchemaObject::Part
        
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
