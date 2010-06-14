require 'dbagile/engine/commands/basics'
require 'dbagile/engine/commands/connections'
require 'dbagile/engine/commands/schema'
require 'dbagile/engine/commands/data'
require 'dbagile/engine/commands/queries'
module DbAgile
  class Engine
    class Runner
      include DbAgile::Engine::Basics
      include DbAgile::Engine::Connections
      include DbAgile::Engine::Data
      include DbAgile::Engine::Queries
      include DbAgile::Engine::Schema
      
      # The engine
      attr_reader :engine
      
      # Creates a runner instance
      def initialize(engine)
        @engine = engine
      end
      
    end # class Runner
  end # class Engine
end # module DbAgile