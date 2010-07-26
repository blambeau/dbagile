module DbAgile
  module Core
    module Schema
      class Logical
        class ForeignKey < Constraint
        
          # Returns relation variable on which this foreign key is installed.
          def source_relvar
            parent.parent
          end
          alias :referencing_relvar :source_relvar
          
          # Returns target relation variable (aka) referenced_relvar
          def target_relvar
            schema.logical.relation_variable(definition[:references])
          end
          alias :referenced_relvar :target_relvar
          
          ############################################################################
          ### Public check interface
          ############################################################################
          
          # @see DbAgile::Core::Schema::SchemaObject
          def _semantics_check(clazz, errors)
            if (srv = source_relvar).nil?
              raise DbAgile::SchemaInternalError, "Foreign key without source relvar"
            elsif !srv.has_attributes?(definition[:source])
              code = clazz::InvalidForeignKey | clazz::NoSuchRelvarAttributes
              errors.add_error(self, code, :relvar_name => srv.name,
                                           :attributes  => definition[:source])
            end
            if (trv = target_relvar).nil?
              code = clazz::InvalidForeignKey | clazz::NoSuchRelvar
              errors.add_error(self, code, :relvar_name => definition[:references])
            elsif !trv.has_attributes?(definition[:target])
              code = clazz::InvalidForeignKey | clazz::NoSuchRelvarAttributes
              errors.add_error(self, code, :relvar_name => trv.name,
                                           :attributes  => definition[:target])
            end
          end
      
          ############################################################################
          ### About IO
          ############################################################################
        
          # Delegation pattern on YAML flushing
          def to_yaml(opts = {})
            YAML::quick_emit(self, opts){|out|
              defn = definition
              source = Schema::Builder::Coercion::unsymbolize_array(definition[:source])
              target = Schema::Builder::Coercion::unsymbolize_array(definition[:target])
              out.map("tag:yaml.org,2002:map", :inline ) do |map|
                map.add('type', definition[:type])
                map.add('references', definition[:references].to_s)
                map.add('source', source)
                map.add('target', target)
              end
            }
          end

        end # class ForeignKey
      end # module Logical
    end # module Schema
  end # module Core
end # module DbAgile
