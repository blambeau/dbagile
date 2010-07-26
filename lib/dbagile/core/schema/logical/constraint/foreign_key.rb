module DbAgile
  module Core
    module Schema
      class Logical
        class ForeignKey < Constraint
        
          # Returns relation variable on which this foreign key is installed.
          def source_relvar
            relation_variable
          end
          alias :referencing_relvar :source_relvar
          
          # Collects referencing attributes on the source relvar
          def source_attributes
            rv = source_relvar
            definition[:source].collect{|attr_name| rv.heading[attr_name]}
          end
          
          # Returns target relation variable (aka) referenced_relvar
          def target_relvar
            schema.logical.relation_variable(definition[:references])
          end
          alias :referenced_relvar :target_relvar
          
          # Collects referencing attributes on the source relvar
          def target_attributes
            rv = target_relvar
            definition[:target].collect{|attr_name| rv.heading[attr_name]}
          end
          
          ############################################################################
          ### Public check interface
          ############################################################################
          
          # @see DbAgile::Core::Schema::SchemaObject
          def _semantics_check(clazz, errors)
            failed = false
            
            # 1) check source and target relvars
            if (srv = source_relvar).nil?
              raise DbAgile::SchemaInternalError, "Foreign key without source relvar"
            end
            if (trv = target_relvar).nil?
              code = clazz::InvalidForeignKey | clazz::NoSuchRelvar
              errors.add_error(self, code, :relvar_name => definition[:references])
              failed = true
            end
            return if failed
            
            # 2) Both exist, check attributes now
            if !srv.has_attributes?(definition[:source])
              code = clazz::InvalidForeignKey | clazz::NoSuchRelvarAttributes
              errors.add_error(self, code, :relvar_name => srv.name,
                                           :attributes  => definition[:source])
              failed = true
            end
            if !trv.has_attributes?(definition[:target])
              code = clazz::InvalidForeignKey | clazz::NoSuchRelvarAttributes
              errors.add_error(self, code, :relvar_name => trv.name,
                                           :attributes  => definition[:target])
              failed = true
            end
            return if failed
            
            # 3) Both exist as well as attributes... type-checking now 
            source_attrs, target_attrs = source_attributes, target_attributes
            if source_attrs.size != target_attrs.size
              code = clazz::InvalidForeignKey | clazz::AttributeMismatch
              errors.add_error(self, code)
            else
              source_domains = source_attrs.collect{|a| a.domain}
              target_domains = target_attrs.collect{|a| a.domain}
              if source_domains != target_domains
                code = clazz::InvalidForeignKey | clazz::AttributeMismatch
                errors.add_error(self, code)
              end
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
