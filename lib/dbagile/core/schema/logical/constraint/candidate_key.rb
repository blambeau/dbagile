module DbAgile
  module Core
    module Schema
      class Logical
        class CandidateKey < Constraint
        
          ############################################################################
          ### Candidate key
          ############################################################################
          
          # Is it a primary key?
          def primary?
            definition[:type] == :primary_key
          end
          
          # Returns key attributes
          def key_attributes
            rv = relation_variable
            definition[:attributes].collect{|k| rv.heading[k]}
          end
          
          ############################################################################
          ### Dependency control
          ############################################################################
          
          # @see DbAgile::Core::Schema::SchemaObject
          def dependencies(include_parent = false)
            include_parent ? [ parent ] + key_attributes : key_attributes
          end
          
          ############################################################################
          ### Check interface
          ############################################################################
          
          # @see DbAgile::Core::Schema::SchemaObject
          def _semantics_check(clazz, buffer)
            rv = relation_variable
            unless rv.heading.has_attributes?(definition[:attributes])
              error_code = clazz::InvalidCandidateKey | clazz::NoSuchRelvarAttributes
              buffer.add_error(self, error_code, :relvar_name => rv.name, 
                                                 :attributes  => definition[:attributes])
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
