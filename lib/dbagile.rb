module DbAgile
  
  # Version of the DbAgile interface
  VERSION = "0.0.1".freeze
  
  # Connects to a database and returns a Database instance
  def connect(uri, &block)
    uri = case uri
      when String 
        SequelAdapter.new(uri)
      when Adapter
        uri
      else
        raise ArgumentError, "Unable to use #{uri} for accessing database"
    end
    db = Database.new(uri)
    FlexibleDSL.new(db).send(:execute, &block) if block
    db
  end
  module_function :connect
  
end # module DbAgile
require 'dbagile/adapter'
require 'dbagile/plugin'
require 'dbagile/flexible_dsl'
require 'dbagile/database'
