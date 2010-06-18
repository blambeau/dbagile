module DbAgile
  module Contract
    module TransactionSupport
      
      #
      # Yields the block inside a transaction. 
      #
      # Adapters are expected to catch the DbAgile::Errors::AbordTransactionError
      # and to rollback the transaction without re-raising the error.
      #
      # @return [...] block's result
      #
      def transaction(&block)
        Kernel.raise NotImplementedError
      end
      
    end # module TransactionSupport
  end # module Contract
end # module DbAgile