module DbAgile
  module Core
    module Schema
      class Builder
        module Coercion
        
          ###############################################################################
          ### Tools
          ###############################################################################
          def unsymbolize_hash(h)
            unsymbolized = {}
            h.each_pair{|k,v| unsymbolized[k.to_s] = v}
            unsymbolized
          end
          module_function :unsymbolize_hash
        
          # Unsymbolizes an array of names
          def unsymbolize_array(array)
            array.collect{|c| c.to_s}
          end
          module_function :unsymbolize_array
        
          ###############################################################################
          ### Validity
          ###############################################################################
        
          # Raises a DbAgile::SchemaSyntaxError
          def invalid!(msg)
            raise DbAgile::SchemaSyntaxError, msg, caller
          end
        
          # Raises a coercion error
          def coercion_error!(msg = "")
            raise ::SByC::TypeSystem::CoercionError, msg, caller
          end
        
          # Asserts that all args are not nil
          def not_nil!(*args)
            if args.any?{|arg| arg.nil?}
              coercion_error!
            end
            args
          end
          
          # Asserts that all args are not empty
          def not_empty!(*args)
            if args.any?{|arg| arg.nil? or arg.to_s.empty?}
              coercion_error!
            end
            args
          end
        
          # Asserts that a hash is not nil and a hash
          def not_nil_hash!(hash)
            not_nil!(hash)
            unless hash.kind_of?(Hash)
              coercion_error!("Hash expected, #{hash.class} received")
            end
            hash
          end
          
          def has_exactly_hash_keys!(hash, *keys)
            not_nil!(hash)
            unless keys.all?{|k| hash.key?(k)}
              coercion_error!("Expected #{keys.inspect}, found #{hash.keys.inspect}")
            end
            hash
          end
        
          # Asserts that a name is valid
          def valid_name!(name)
            not_empty!(name)
            unless [String, Symbol].include?(name.class)
              coercion_error!
            end
            name
          end
        
          ###############################################################################
          ### Data types (coercion error)
          ###############################################################################
        
          # Coerces an array
          def coerce_array(array, non_empty)
            unless array.kind_of?(Array)
              coercion_error!
            end
            if non_empty and array.empty?
              coercion_error!
            end
            array
          end
        
          # Coerces a symbolized hash
          def coerce_symbolized_hash(hash, recursive = false)
            hash = not_nil_hash!(hash)
            symbolized = {}
            hash.each_pair{|k,v| 
              if recursive and v.kind_of?(Hash)
                v = coerce_symbolized_hash(v)
              end
              symbolized[coerce_name(k)] = v
            }
            symbolized
          end
        
          ###############################################################################
          ### Sub-concepts (coercion error)
          ###############################################################################
        
          # Coerces a name
          def coerce_name(name)
            valid_name!(name)
            name.to_s.to_sym
          end
          alias :coerce_relvar_name :coerce_name
          alias :coerce_attribute_name :coerce_name
          alias :coerce_constraint_name :coerce_name
          alias :coerce_index_name :coerce_name
        
          # Coerces a default value
          def coerce_default_value(value, domain)
            not_nil!(value, domain)
            if value.kind_of?(Symbol)
              case value 
                when :autonumber
                  :autonumber
                else
                  invalid!("unknown default value handler #{value}") 
              end
            else
              SByC::TypeSystem::Ruby::coerce(value, domain)
            end
          end
        
          # Coerces a domain
          def coerce_domain(domain)
            not_nil!(domain)
            domain = SByC::TypeSystem::Ruby::coerce(domain, Module)
            unless DbAgile::RECOGNIZED_DOMAINS.include?(domain)
              invalid!("unable to use #{domain} for attribute domain")
            end
            domain
          end
        
          # Coerces a mandatory value
          def coerce_mandatory(mandatory)
            mandatory.nil? ? true : SByC::TypeSystem::Ruby::coerce(mandatory, SByC::TypeSystem::Ruby::Boolean)
          end
        
          # Coerces attributes names
          def coerce_attribute_names(defn, non_empty = true)
            defn = coerce_array(defn, non_empty)
            defn.collect{|c| coerce_name(c)}
          end

          ###############################################################################
          ### Concepts (coercion error)
          ###############################################################################
        
          # Coerces an attribute definition
          def coerce_attribute_definition(defn)
            defn = coerce_symbolized_hash(defn)
            defn[:domain] = coerce_domain(defn[:domain])
            if defn.key?(:default)
              defn[:default] = coerce_default_value(defn[:default], defn[:domain])
            end
            defn[:mandatory] = coerce_mandatory(defn[:mandatory])
            defn
          end
        
          # Coerces a constraint definition
          def coerce_constraint_definition(defn)
            defn = coerce_symbolized_hash(defn)
            defn[:type] = coerce_name(defn[:type])
            
            case type = defn[:type]
              when :primary_key, :candidate_key
                has_exactly_hash_keys!(defn, :type, :attributes)
                defn[:attributes] = coerce_attribute_names(defn[:attributes], true)
              when :foreign_key
                if defn.key?(:key)
                  has_exactly_hash_keys!(defn, :type, :attributes, :references, :key)
                  defn[:attributes] = coerce_attribute_names(defn[:attributes], true)
                  defn[:references] = coerce_name(defn[:references])
                  defn[:key]        = coerce_name(defn[:key])
                else
                  has_exactly_hash_keys!(defn, :type, :attributes, :references)
                  defn[:attributes] = coerce_attribute_names(defn[:attributes], true)
                  defn[:references] = coerce_name(defn[:references])
                end
              else
                invalid!("unknown constraint type #{type}")
            end
            defn
          end

          # Coerces an index definition
          def coerce_index_definition(defn)
            defn = coerce_symbolized_hash(defn)
            defn[:relvar] = coerce_name(defn[:relvar])
            defn[:attributes] = coerce_attribute_names(defn[:attributes], true)
            defn
          end
         
        end # module Coercion
      end # class Builder
    end # module Schema
  end # module Core
end # module DbAgile