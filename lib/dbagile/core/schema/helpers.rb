module DbAgile
  module Core
    class Schema
      module Helpers
      
        # Symbolizes a hash
        def symbolize_hash(hash, recursive = false)
          symbolized = {}
          hash.each_pair{|k,v| 
            if recursive and v.kind_of?(Hash)
              v = symbolize_hash(v)
            end
            symbolized[k.to_sym] = v
          }
          symbolized
        end
      
        # Raises a DbAgile::Error
        def invalid!(message)
          raise DbAgile::Error, "Invalid DbAgile schema: #{message}"
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
      
      end # module Helpers
    end # class Schema
  end # module Core
end # module DbAgile