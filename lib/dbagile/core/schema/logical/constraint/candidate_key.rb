module DbAgile
  module Core
    module Schema
      class Logical
        class CandidateKey < Constraint
        
          # Is it a primary key?
          def primary?
            definition[:type] == :primary_key
          end
          
          # Returns key attributes
          def attributes
            definition[:attributes]
          end
          
          ############################################################################
          ### Check interface
          ############################################################################
          
          # @see DbAgile::Core::Schema::SchemaObject
          def _semantics_check(clazz, buffer)
            rv = relation_variable
            unless rv.has_attributes?(attributes)
              error_code = clazz::InvalidCandidateKey | clazz::NoSuchRelvarAttributes
              buffer.add_error(self, error_code, :relvar_name => rv.name, 
                                                 :attributes  => attributes)
            end
          end
      
          ############################################################################
          ### About IO
          ############################################################################
        
          # Delegation pattern on YAML flushing
          def to_yaml(opts = {})
            YAML::quick_emit(self, opts){|out|
              defn = definition
              attrs = Schema::Builder::Coercion::unsymbolize_array(definition[:attributes])
              out.map("tag:yaml.org,2002:map", :inline ) do |map|
                map.add('type', definition[:type])
                map.add('attributes', attrs)
              end
            }
          end
          
        end # class CandidateKey
      end # module Logical
    end # module Schema
  end # module Core
end # module DbAgile
