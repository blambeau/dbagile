module DbAgile
  module Core
    class Schema
      class Builder
        module Helpers
      
          ###############################################################################
          ### Symbolization
          ###############################################################################
           
          # Symbolizes a name
          def symbolize_name(name)
            name.to_s.to_sym
          end
      
          # Symbolizes an array
          def symbolize_array(array)
            array.collect{|s| symbolize_name(array)}
          end
      
          # Symbolizes a hash
          def symbolize_hash(hash, recursive = false)
            symbolized = {}
            hash.each_pair{|k,v| 
              if recursive and v.kind_of?(Hash)
                v = symbolize_hash(v)
              end
              symbolized[symbolize_name(k)] = v
            }
            symbolized
          end
          
          ###############################################################################
          ### Validity
          ###############################################################################
           
          # Raises a DbAgile::Error
          def invalid!(message)
            raise DbAgile::Error, "Invalid DbAgile schema: #{message}"
          end
      
          # Asserts that something is a array and symbolized it
          def symbolized_array!(array, no_empty = true)
            invalid!("array expected, got #{array.inspect}") unless array.kind_of?(Array)
            invalid!("non-empty array expected") if no_empty and array.empty?
            symbolize_array(array)
          end
      
          # Asserts that something is a symbolized hash
          def symbolized_hash!(object, size = nil, valid_values = nil)
            invalid!("Hash expected, got #{object.class}") unless object.kind_of?(Hash)
            unless size.nil? or object.size == size
              invalid!("size #{s} expected, got #{object.inspect}") 
            end
            symbolized = symbolize_hash(object)
            unless valid_values.nil? or symbolized.keys.all?{|v| valid_values.include?(v)}
              invalid!("one of #{valid_values.inspect} expected")
            end
            symbolized
          end
          
          # Asserts that a given hash has expected keys
          def hash_has_keys!(hash, *keys)
            keys.each{|k|
              unless hash.key?(k)
                invalid!("expected #{k} in #{hash.inspect}")
              end
            }
            hash
          end
          
          ###############################################################################
          ### Concepts validity
          ###############################################################################
          
          # Asserts that a default value is valid
          def valid_default_value!(definition)
            return unless definition.key?(:default)
            default, domain = definition[:default], definition[:domain]
            if default.kind_of?(Symbol)
              case default 
                when :autonumber
                else
                  invalid!("unknown default value handler #{default}") 
              end
            else
              SByC::TypeSystem::Ruby::coerce(default, domain)
            end
          end
          
          # Asserts and coerces an attribute definition
          def attribute_def_hash!(definition)
            h = symbolized_hash!(definition, nil, [ :domain, :mandatory, :default ])
            
            # Validate domain
            # WARNING: we rely on Kernel.eval here...
            hash_has_keys!(h, :domain)
            h[:domain] = SByC::TypeSystem::Ruby::coerce(h[:domain], Class)
            unless DbAgile::RECOGNIZED_DOMAINS.include?(h[:domain])
              invalid!("unable to use #{h[:domain]} for attribute domain")
            end
            
            # Validate default value
            valid_default_value!(h)
            
            # Validate mandatory
            if h.key?(:mandatory)
              h[:mandatory] = SByC::TypeSystem::Ruby::coerce(h[:mandatory], SByC::TypeSystem::Ruby::Boolean)
            else
              h[:mandatory] = true
            end
            
            h
          end
          
          # Asserts and coerces a constraint definition
          def constraint_def_hash!(definition)
            h = symbolize_hash(definition)
            hash_has_keys!(h, :type)
            case type = h[:type]
              when :primary_key, :candidate_key, :key
                hash_has_keys!(h, :attributes)
                h[:attributes] = symbolized_array!(h[:attributes], true)
              when :foreign_key
                hash_has_keys!(h, :references, :source, :target)
                h[:references] = symbolize_name(h[:references])
                h[:source] = symbolized_array!(h[:source], true)
                h[:target] = symbolized_array!(h[:source], true)
              else
                invalid!("unknown constraint type #{type}")
            end
            h
          end
          
          def index_def_hash!(definition)
            h = symbolized_hash!(definition, nil, [ :relvar, :attributes ])
            hash_has_keys!(h, :relvar, :attributes)
            h[:relvar] = symbolize_name(h[:relvar])
            h[:attributes] = symbolized_array!(h[:attributes], true)
            h
          end
          
        end # module Helpers
      end # class Builder 
    end # class Schema
  end # module Core
end # module DbAgile