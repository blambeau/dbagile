module DbAgile
  module Contract
    # Connection driven methods of the contract
    module Connection
      
      # 
      # Ping the SQL server, returns true if everything is fine. Raises an
      # error otherwise
      #
      # @return true
      #
      def ping
        Kernel.raise NotImplementedError
      end
      
      # 
      # Ping the SQL server, returns true if everything is fine, false 
      # otherwise.
      #
      def ping?
        ping
        true
      rescue StandardError
        false
      end
      
      #
      # Returns the database schema as a DbAgile::Core::Schema instance
      #
      def database_schema
        Kernel.raise NotImplementedError
      end
      
      # 
      # Disconnect the adapter and frees all resources.
      #
      # @return true
      #
      def disconnect
        Kernel.raise NotImplementedError
      end
    
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
      
    end # module Connection
  end # module Contract
end # module DbAgile