require 'dbagile/engine/commands/basics'
require 'dbagile/engine/commands/connections'
require 'dbagile/engine/commands/schema'
require 'dbagile/engine/commands/data'
require 'dbagile/engine/commands/queries'
require 'dbagile/engine/commands/facts'
module DbAgile
  class Engine
    class Runner
      include DbAgile::Adapter::Tools
      include DbAgile::Engine::Basics
      include DbAgile::Engine::Connections
      include DbAgile::Engine::Data
      include DbAgile::Engine::Queries
      include DbAgile::Engine::Schema
      include DbAgile::Engine::Facts
      
      # The engine
      attr_reader :engine
      
      # The current transaction
      attr_reader :transaction
      
      # Creates a runner instance
      def initialize(engine)
        @engine = engine
      end
      
      # Asserts that a transaction has been started
      def has_transaction!
        raise NoPendingTransactionError, "No running transaction."\
          unless @transaction
      end
      
      # Returns engine's connection
      def connection
        engine.connected!
        engine.connection
      end
      
      # Starts transaction
      def start_transaction
        raise "Transaction already running" if @transaction
        @transaction = connection.transaction{|t| t}
      end
      
      # Commits the current transaction
      def commit
        has_transaction!
        @transaction.commit
        @transaction = nil
      end
      
      # Rollbacks the current transaction
      def rollback
        has_transaction!
        @transaction.commit
        @transaction = nil
      end
      
    end # class Runner
  end # class Engine
end # module DbAgile