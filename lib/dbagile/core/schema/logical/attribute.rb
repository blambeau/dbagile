module DbAgile
  module Core
    module Schema
      class Logical
        class Attribute < Schema::Part
        
          ############################################################################
          ### Attribute
          ############################################################################
          
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
          ### Dependency control
          ############################################################################
          
          # @see DbAgile::Core::Schema::SchemaObject
          def dependencies(include_parent = false)
            include_parent ? [ parent ] : []
          end
          
          ############################################################################
          ### Check interface
          ############################################################################
          
          # @see DbAgile::Core::Schema::SchemaObject
          def _semantics_check(clazz, buffer)
            unless default_value.nil? or default_value.kind_of?(domain)
              buffer.add_error(self, clazz::InvalidDefaultValue)
            end
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
    end # module Schema
  end # module Core
end # module DbAgile
