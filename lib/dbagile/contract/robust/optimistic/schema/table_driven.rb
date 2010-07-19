module DbAgile
  module Contract
    module Robust
      class Optimistic
        module Schema
          module TableDriven
            
            # @see DbAgile::Contract::Schema::TableDriven#has_column?
            def has_column?(*args, &block)
              delegate.has_column?(*args, &block)
            rescue
              has_table!(args[0])
              raise
            end
        
            # @see DbAgile::Contract::Schema::TableDriven#column_names
            def column_names(*args, &block)
              delegate.column_names(*args, &block)
            rescue
              has_table!(args[0])
              raise
            end
      
            # @see DbAgile::Contract::Schema::TableDriven#is_key
            def is_key?(*args, &block)
              delegate.is_key?(*args, &block)
            rescue
              has_table!(args[0])
              raise
            end
      
            # @see DbAgile::Contract::Schema::TableDriven#keys
            def keys(*args, &block)
              delegate.keys(*args, &block)
            rescue
              has_table!(args[0])
              raise
            end

          end # module Schema
        end # module Data
      end # class Optimistic
    end # module Robust
  end # module Contract
end # module DbAgile