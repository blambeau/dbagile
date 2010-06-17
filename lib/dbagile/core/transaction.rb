module DbAgile
  module Core
    class Transaction
    
      ### VARS AND INITIALIZE ######################################################
    
      # Underlying connection
      attr_reader :connection
    
      # Creates a Transaction instance
      def initialize(connection)
        @connection = connection
      end
    
      ### ABOUT TRANSACTION MANAGEMENT #############################################
    
      # Commits the transaction
      def commit
      end
    
      # Rollbacks the transaction
      def rollback
      end
    
      ### DELEGATE PATTERN #########################################################
      
      # Automatically install methods of the ConnectionDriven contract
      DbAgile::Contract::ConnectionDriven.instance_methods(false).each do |method|
        self.module_eval <<-EOF
          def #{method}(*args)
            connection.#{method}(*args)  
          end
        EOF
      end

      # Automatically install methods of the TableDriven contract
      DbAgile::Contract::TableDriven.instance_methods(false).each do |method|
        self.module_eval <<-EOF
          def #{method}(*args)
            connection.#{method}(*args)  
          end
        EOF
      end

      # Automatically install methods of the TransactionDriven contract
      DbAgile::Contract::TransactionDriven.instance_methods(false).each do |method|
        self.module_eval <<-EOF
          def #{method}(*args)
            connection.find_delegate(args[0]).#{method}(self, *args)  
          end
        EOF
      end

    end # class Transaction
  end # module Core
end # module DbAgile