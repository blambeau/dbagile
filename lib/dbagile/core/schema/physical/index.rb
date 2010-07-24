module DbAgile
  module Core
    module Schema
      class Physical < Schema::Composite
        class Index < Schema::Part

          ############################################################################
          ### About IO
          ############################################################################
      
          # Delegation pattern on YAML flushing
          def to_yaml(opts = {})
            YAML::quick_emit(self, opts){|out|
              defn = definition
              attrs = Schema::Builder::Coercion::unsymbolize_array(definition[:attributes])
              out.map("tag:yaml.org,2002:map", :inline ) do |map|
                map.add('relvar', definition[:relvar].to_s)
                map.add('attributes', attrs)
              end
            }
          end
        
        end # class Index
      end # module Physical
    end # module Schema
  end # module Core
end # module DbAgile
