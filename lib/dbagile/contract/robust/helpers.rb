module DbAgile
  module Contract
    module Robust
      module Helpers
    
        # Asserts that a table exists or raises a NoSuchTableError
        def has_table!(name, ex = nil)
          raise NoSuchTableError, "No such table #{name}" unless has_table?(name)
        end
    
        # Asserts that a table does not exist or raises a TableAlreadyExistsError
        def not_has_table!(name, ex = nil)
          raise TableAlreadyExistsError, "No such table #{name}" if has_table?(name)
        end
  
      end # module Helpers
    end # module Robust
  end # module Contract
end # module DbAgile
