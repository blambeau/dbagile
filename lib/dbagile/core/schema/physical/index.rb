module DbAgile
  module Core
    module Schema
      class Physical < Schema::Composite
        class Index < Schema::Part

          # Relation variable targettet by this index
          def indexed_relvar
            schema.logical.relation_variable(definition[:relvar])
          end

          ############################################################################
          ### Check interface
          ############################################################################
          
          # @see DbAgile::Core::Schema::SchemaObject
          def _semantics_check(clazz, errors)
            if (trv = indexed_relvar).nil?
              code = clazz::InvalidIndex | clazz::NoSuchRelvar
              errors.add_error(self, code, :relvar_name => definition[:relvar])
            elsif !trv.heading.has_attributes?(definition[:attributes])
              code = clazz::InvalidIndex | clazz::NoSuchRelvarAttributes
              errors.add_error(self, code, :relvar_name => trv.name,
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
