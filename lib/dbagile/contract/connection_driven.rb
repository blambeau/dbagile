module DbAgile
  module Contract
    # Connection driven methods of the contract
    module ConnectionDriven
      
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
      # Disconnect the adapter and frees all resources.
      #
      # @return true
      #
      def disconnect
        Kernel.raise NotImplementedError
      end
    
    end # module ConnectionBased
  end # module Contract
end # module DbAgile