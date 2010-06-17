module DbAgile
  module Contract
    module TransactionSupport
      
      #
      # Yields the block inside a transaction
      #
      # @return [...] block's result
      #
      def transaction(&block)
        Kernel.raise NotImplementedError
      end
      
    end # module TransactionSupport
  end # module Contract
end # module DbAgile