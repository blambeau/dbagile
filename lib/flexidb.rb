module FlexiDB
  
  # Version of the FlexiDB interface
  VERSION = "0.0.1".freeze
  
  # Connects to a database and returns a Database instance
  def connect(uri)
    Database.new(SequelAdapter.new(uri))
  end
  module_function :connect
  
end # module FlexiDB
require 'flexidb/adapter'
require 'flexidb/utils'
require 'flexidb/database'
