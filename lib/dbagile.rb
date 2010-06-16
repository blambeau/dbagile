module DbAgile
  
  # Version of the DbAgile interface
  VERSION = "0.0.1".freeze
  
  # Installed configurations
  CONFIGURATIONS = {}
  
  #
  # When a block if given, creates a configuration instance and saves it 
  # under _name_ (if name is given).
  #
  # When no block is given, returns a configuration by name
  # 
  def config(name = nil, &block)
    if block
      config = DbAgile::Core::Configuration.new(&block)
      (CONFIGURATIONS[name] = config) if name
      config
    else
      CONFIGURATIONS[name]
    end
  end
  module_function :config
  
  # Connects to a database and returns a Database instance
  def connect(uri, options = {}, &block)
    connection = case uri
      when Symbol
        if c = config(uri)
          c.connect(nil, options)
        else
          raise UnknownConfigurationError, "Unknown configuration #{uri}"
        end
      when String
        DbAgile::Core::Configuration.new.connect(uri, options)
      else
        raise ArgumentError, "Unable to use #{uri} for accessing database"
    end
    connection
  end
  module_function :connect
  
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
  
end # module DbAgile

require 'rubygems'
gem "sbyc", ">= 0.1.2"
gem "sequel", ">= 3.8.0"
require 'sbyc'
require 'sequel'

require 'dbagile/errors'
require 'dbagile/ext/object'
require 'dbagile/utils'
require 'dbagile/adapter'
require 'dbagile/core'
require 'dbagile/plugin'
