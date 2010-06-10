module DbAgile
  
  # Version of the DbAgile interface
  VERSION = "0.0.1".freeze
  
  #
  # Starts an engine and executes source (which is expected to start with a 
  # connect command)
  #
  def execute(source = nil, &block)
    engine = DbAgile::Engine.new(DbAgile::Engine::DslEnvironment.new(source || block))
    engine.execute
    engine.database
  end
  module_function :execute
  
  # Connects to a database and returns a Database instance
  def connect(uri, &block)
    return uri if uri.kind_of?(DbAgile::Database)
    uri = case uri
      when String 
        SequelAdapter.new(uri)
      when Adapter
        uri
      else
        raise ArgumentError, "Unable to use #{uri} for accessing database"
    end
    db = Database.new(uri)
    db.execute(block) if block
    db
  end
  module_function :connect
  
end # module DbAgile
require 'dbagile/adapter'
require 'dbagile/plugin'
require 'dbagile/database'
