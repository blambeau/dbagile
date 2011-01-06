module DbAgile
  module Core
    module Schema
      module Robustness
        
        #
        # Asserts that _arg_ is a Schema::DatabaseSchema or raises an ArgumentError
        #
        def schema!(arg, arg_name = :schema, cal = caller)
          unless arg.kind_of?(Schema::DatabaseSchema)
            raise ArgumentError, "Schema expected for #{arg_name}, got #{arg.class}", cal
          end
          arg
        end
        
        #
        # Asserts that _arg_ is a Schema::Builder or raises an ArgumentError
        #
        def builder!(arg, arg_name = :builder, cal = caller)
          unless arg.kind_of?(Schema::Builder)
            raise ArgumentError, "Builder expected for #{arg_name}, got #{arg.class}", cal
          end
          arg
        end
        
        #
        # Asserts that _arg_ is a Hash or raises an ArgumentError
        #
        def hash!(arg, arg_name = :options, cal = caller)
          unless arg.kind_of?(Hash)
            raise ArgumentError, "Hash expected for #{arg_name}, got #{arg.class}", cal
          end
          arg
        end
        
      end # module Robustness
    end # module Schema
  end # module Core
end # module DbAgile