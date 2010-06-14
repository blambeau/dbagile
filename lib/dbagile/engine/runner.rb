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
      
      # Creates a runner instance
      def initialize(engine)
        @engine = engine
      end
      
    end # class Runner
  end # class Engine
end # module DbAgile