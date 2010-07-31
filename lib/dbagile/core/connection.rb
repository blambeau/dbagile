module DbAgile
  module Core
    class Connection
    
      attr_reader :chain
    
      # About creation ###############################################################
    
      # Creates a database instance with an underlying adapter
      def initialize(chain)
        @chain = chain
      end
    
      # About delegate chains ########################################################
      
      # Hot plug
      def plug(*args)
        @chain.plug(*args)
      end
    
      # Delegated to the chain
      def inspect
        @chain.inspect
      end
    
      ### DELEGATE PATTERN ON CONNECTION ################################################

      # Automatically install methods of the Connection and *::TableDriven contracts
      [ DbAgile::Contract::Connection,
        DbAgile::Contract::Data::TableDriven,
        DbAgile::Contract::Schema::TableDriven ].each do |mod|

        mod.instance_methods(false).each do |method|
          self.module_eval <<-EOF
            def #{method}(*args, &block)
              @chain.#{method}(*args, &block)  
            end
          EOF
        end

      end
    
      # Executes the block inside a transaction.
      def transaction(&block)
        raise ArgumentError, "Missing transaction block" unless block
        Transaction.new(self).execute(&block)
      end
      
    end # class Connection
  end # module Core
end # module DbAgile