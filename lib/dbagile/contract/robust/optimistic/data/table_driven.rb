module DbAgile
  module Contract
    module Robust
      class Optimistic
        module Data
          module TableDriven
            
            # @see DbAgile::Contract::Data::TableDriven#dataset
            def dataset(*args, &block)
              ds = delegate.dataset(*args, &block)
              ds.empty?
              ds
            rescue StandardError => ex
              has_table!(args[0], ex)
              raise
            end
      
            # @see DbAgile::Contract::Data::TableDriven#exists?
            def exists?(*args, &block)
              delegate.exists?(*args, &block)
            rescue StandardError => ex
              has_table!(args[0], ex)
              raise
            end
            
          end # module TableDriven
        end # module Data
      end # class Optimistic
    end # module Robust
  end # module Contract
end # module DbAgile
