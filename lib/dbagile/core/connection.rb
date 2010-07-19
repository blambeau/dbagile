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
    
      ### DELEGATE PATTERN ON CONNECTION ################################################

      # Automatically install methods of the Connection contract
      DbAgile::Contract::Connection.instance_methods(false).each do |method|
        self.module_eval <<-EOF
          def #{method}(*args, &block)
            main_delegate.#{method}(*args, &block)  
          end
        EOF
      end
    
      ### TRANSACTIONS AND WRITE ACCESSES ###############################################
    
      # Executes the block inside a transaction.
      def transaction(&block)
        raise ArgumentError, "Missing transaction block" unless block
        Transaction.new(self).execute(&block)
      end
      
      # Automatically install methods of the *::TableDriven contract
      [ DbAgile::Contract::Data::TableDriven,
        DbAgile::Contract::Schema::TableDriven ].each do |mod|

        mod.instance_methods(false).each do |method|
          self.module_eval <<-EOF
            def #{method}(*args, &block)
              find_delegate(args[0]).#{method}(*args, &block)  
            end
          EOF
        end

      end
    
    end # class Connection
  end # module Core
end # module DbAgile