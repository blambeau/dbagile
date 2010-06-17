module DbAgile
  module Core
    class Connection
    
      # About creation ###############################################################
    
      # Creates a database instance with an underlying adapter
      def initialize(connector)
        @connector = connector
      end
    
      # About delegate chains ########################################################
      
      # Hot plug
      def plug(*args)
        @connector.plug(*args)
      end
    
      # Returns the main delegate
      def main_delegate
        @connector.main_delegate
      end
      
      # Finds a delegate
      def find_delegate(name)
        @connector.find_delegate(name)
      end
      
      # Delegated to the connector
      def inspect
        @connector.inspect
      end
    
      ### TRANSACTIONS AND WRITE ACCESSES ############################################
    
      # Executes the block inside a transaction.
      def transaction(&block)
        Transaction.new(self).execute(&block)
      end
      
      ### DELEGATE PATTERN #########################################################

      # Automatically install methods of the ConnectionDriven contract
      DbAgile::Contract::ConnectionDriven.instance_methods(false).each do |method|
        self.module_eval <<-EOF
          def #{method}(*args)
            main_delegate.#{method}(*args)  
          end
        EOF
      end
    
      # Automatically install methods of the TableDriven contract
      DbAgile::Contract::TableDriven.instance_methods(false).each do |method|
        self.module_eval <<-EOF
          def #{method}(*args)
            find_delegate(args[0]).#{method}(*args)  
          end
        EOF
      end
    
    end # class Connection
  end # module Core
end # module DbAgile