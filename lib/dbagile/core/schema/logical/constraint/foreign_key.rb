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
            definition[:attributes].collect{|attr_name| rv.heading[attr_name]}
          end
          
          # Returns target relation variable (aka) referenced_relvar
          def target_relvar
            schema.logical.relation_variable(definition[:references])
          end
          alias :referenced_relvar :target_relvar
          
          # Collects referencing attributes on the source relvar
          def target_key
            rv = target_relvar
            if definition.key?(:key)
              rv.constraints.constraint_by_name(definition[:key])
            else
              rv.constraints.primary_key
            end
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
            
            # 2) Both exist, check source attributes
            if !srv.heading.has_attributes?(definition[:attributes])
              code = clazz::InvalidForeignKey | clazz::NoSuchRelvarAttributes
              errors.add_error(self, code, :relvar_name => srv.name,
                                           :attributes  => definition[:attributes])
              failed = true
            end
            return if failed
            
            # 3) Check target key existence and kind now
            trg_key = self.target_key
            if trg_key.nil? or not(trg_key.candidate_key?)
              code = clazz::InvalidForeignKey | clazz::NoSuchCandidateKey
              errors.add_error(self, code, :constraint_name => definition[:key])
              failed = true
            end
            return if failed
            
            source_attrs, target_attrs = source_attributes, trg_key.key_attributes
            if source_attrs.size != target_attrs.size
              code = clazz::InvalidForeignKey | clazz::TargetKeyMismatch
              errors.add_error(self, code, :constraint_name => definition[:key])
            elsif source_attrs.collect{|a| a.domain} != target_attrs.collect{|a| a.domain}
              code = clazz::InvalidForeignKey | clazz::TargetKeyMismatch
              errors.add_error(self, code, :constraint_name => definition[:key])
            end
          end
      
          ############################################################################
          ### About IO
          ############################################################################
        
          # Delegation pattern on YAML flushing
          def to_yaml(opts = {})
            YAML::quick_emit(self, opts){|out|
              defn = definition
              attributes = Schema::Builder::Coercion::unsymbolize_array(definition[:attributes])
              references = definition[:references].to_s
              key        = definition.key?(:key) ? definition[:key].to_s : nil
              out.map("tag:yaml.org,2002:map", :inline ) do |map|
                map.add('type', definition[:type])
                map.add('attributes', attributes)
                map.add('references', definition[:references].to_s)
                map.add('key', key) unless key.nil?
              end
            }
          end

        end # class ForeignKey
      end # module Logical
    end # module Schema
  end # module Core
end # module DbAgile
