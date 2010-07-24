module DbAgile
  module Core
    class Schema < SchemaObject::Composite
      class Physical < SchemaObject::Composite
        class Index < SchemaObject::Part

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
