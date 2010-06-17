module DbAgile
  module Contract
    module TransactionSupport
      
      #
      # Yields the block inside a transaction
      #
      # @return [...] block's result
      #
      def transaction(&block)
        block.call
      end
      
    end # module TransactionSupport
  end # module Contract
end # module DbAgile