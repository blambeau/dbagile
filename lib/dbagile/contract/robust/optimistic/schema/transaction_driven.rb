module DbAgile
  module Contract
    module Robust
      class Optimistic
        module Schema
          module TransactionDriven
            
            # @see DbAgile::Contract::Schema::TransactionDriven#create_table
            def create_table(*args, &block)
              delegate.create_table(*args, &block)
            rescue
              not_has_table!(args[1])
              raise
            end
        
            # @see DbAgile::Contract::Schema::TransactionDriven#drop_table
            def drop_table(*args, &block)
              delegate.drop_table(*args, &block)
            rescue
              has_table!(args[1])
              raise
            end
      
            # @see DbAgile::Contract::Schema::TransactionDriven#add_columns
            def add_columns(*args, &block)
              delegate.add_columns(*args, &block)
            rescue
              has_table!(args[1])
              raise
            end
      
            # @see DbAgile::Contract::Schema::TransactionDriven#key!
            def key!(*args, &block)
              delegate.key!(*args, &block)
            rescue
              has_table!(args[1])
              raise
            end

          end # module TransactionDriven
        end # module Schema
      end # class Optimistic
    end # module Robust
  end # module Contract
end # module DbAgile