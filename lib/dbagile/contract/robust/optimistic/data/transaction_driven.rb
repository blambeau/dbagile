module DbAgile
  module Contract
    module Robust
      class Optimistic
        module Data
          module TransactionDriven
            
            # @see ::DbAgile::Contract::Data::TransactionDriven#insert
            def insert(*args, &block)
              delegate.insert(*args, &block)
            rescue
              has_table!(args[1])
              raise
            end
      
            # @see ::DbAgile::Contract::Data::TransactionDriven#update
            def update(*args, &block)
              delegate.update(*args, &block)
            rescue
              has_table!(args[1])
              raise
            end
      
            # @see ::DbAgile::Contract::Data::TransactionDriven#delete
            def delete(*args, &block)
              delegate.delete(*args, &block)
            rescue
              has_table!(args[1])
              raise
            end
      
            # @see ::DbAgile::Contract::Data::TransactionDriven#direct_sql
            def direct_sql(*args, &block)
              delegate.direct_sql(*args, &block)
            rescue
              has_table!(args[1]) if args[1].kind_of?(::Symbol)
              raise
            end
            
          end # module TransactionDriven
        end # module Data
      end # class Optimistic
    end # module Robust
  end # module Contract
end # module DbAgile