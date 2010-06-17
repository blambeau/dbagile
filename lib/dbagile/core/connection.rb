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
      
      # About connections ############################################################
      
      # Pings the connection
      def ping
        main_delegate.ping
      end
    
      # Disconnect from the database
      def disconnect
        main_delegate.disconnect
      end
    
      ### ABOUT QUERIES ##############################################################
    
      # @see Database#dataset
      def dataset(table_or_query, proj = nil)
        find_delegate(table_or_query).dataset(table_or_query, proj)
      end
    
      # @see Database#exists?
      def exists?(table_or_query, subtuple = {})
        find_delegate(table_or_query).exists?(table_or_query, subtuple)
      end
    
      ### SCHEMA QUERIES #############################################################
    
      # @see Database#has_table?
      def has_table?(table_name)
        find_delegate(table_name).has_table?(table_name)
      end
    
      # @see Database#has_column?
      def has_column?(table_name, column_name)
        find_delegate(table_name).has_column?(table_name, column_name)
      end
    
      # @see Database#column_names(table_name, sort)
      def column_names(table_name, sort = false)
        find_delegate(table_name).column_names(table_name, sort)
      end
    
      # @see Database#keys
      def keys(table_name)
        find_delegate(table_name).keys(table_name)
      end
    
      ### TRANSACTIONS AND WRITE ACCESSES ############################################
    
      # Starts a transaction. If a block is provided, yields it with the transaction 
      # object, commits the transaction at the end and returns nil. Otherwise, returns
      # the transaction object.
      def transaction
        t = Transaction.new(self)
        if block_given?
          begin
            res = yield(t)
            t.commit
            res
          rescue Exception
            t.rollback
            Kernel::raise
          end
        else
          t
        end
      end
      
      # Delegated to the connector
      def inspect
        @connector.inspect
      end
    
    end # class Connection
  end # module Core
end # module DbAgile