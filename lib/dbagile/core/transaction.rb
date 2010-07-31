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
    
      # Executes a block
      def execute(&block)
        raise ArgumentError, "Missing transaction block" unless block
        connection.chain.transaction do
          block.call(self)
        end
      end
    
      # Commits the transaction
      def commit
      end
    
      # Rollbacks the transaction
      def rollback
        raise DbAgile::AbordTransactionError
      end
    
      ### DELEGATE PATTERN #########################################################
      
      # Automatically install methods of the Connection contract
      DbAgile::Contract::Connection.instance_methods(false).each do |method|
        next if method == :transaction
        self.module_eval <<-EOF
          def #{method}(*args)
            connection.chain.#{method}(*args)  
          end
        EOF
      end
      
      # Executes the block inside this transaction
      def transaction(&block)
        execute(&block)
      end

      # Automatically install methods of the *::TableDriven contract
      [ DbAgile::Contract::Data::TableDriven,
        DbAgile::Contract::Schema::TableDriven ].each do |mod|

        mod.instance_methods(false).each do |method|
          self.module_eval <<-EOF
            def #{method}(*args)
              connection.chain.#{method}(*args)  
            end
          EOF
        end
      
      end # *::TableDriven

      # Automatically install methods of the *::TransactionDriven contract
      [ DbAgile::Contract::Data::TransactionDriven,
        DbAgile::Contract::Schema::TransactionDriven ].each do |mod|

        mod.instance_methods(false).each do |method|
          self.module_eval <<-EOF
            def #{method}(*args)
              connection.chain.#{method}(self, *args)  
            end
          EOF
        end
        
      end

      private :connection
    end # class Transaction
  end # module Core
end # module DbAgile