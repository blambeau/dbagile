module DbAgile
  
  # Version of the DbAgile interface
  VERSION = "0.0.1".freeze
  
  # Installed configurations
  CONFIGURATIONS = {}
  
  # Force use of a specific user configuration file
  def user_config_file=(file)
    @user_config_file = file
  end
  module_function :user_config_file=

  # Returns default user configuration file
  def user_config_file
    @user_config_file || File.join(ENV['HOME'], '.dbagile')
  end
  module_function :user_config_file
  
  #
  # Loads a configuration file and returns a DbAgile::Core::ConfigFile 
  # instance. 
  #
  # @param [String] file path of the configuration file to load
  # @raise CorruptedConfigFileError if something is wrong.
  # @raise NoConfigFileError if the file cannot be found.
  #
  def load_user_config_file(file = user_config_file)
    raise NoConfigFileError, "No such config file #{file}" unless File.exists?(file)
    raise CorruptedConfigFileError, "Corrupted config file #{file}" unless File.file?(file) and File.readable?(file)
    begin
      ::DbAgile::Core::ConfigFile.new(file)
    rescue Exception => ex
      raise CorruptedConfigFileError, "Corrupted config file #{file}", ex
    end
  end
  module_function :load_user_config_file
  
  #
  # When a block if given, creates a configuration instance and saves it 
  # under _name_ (if name is given).
  #
  # When no block is given, returns a configuration by name
  # 
  def config(name = :noname, &block)
    if block
      config = DbAgile::Core::Configuration.new(name, &block)
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
  
end # module DbAgile

require 'rubygems'
gem "sbyc", ">= 0.1.2"
gem "sequel", ">= 3.8.0"
require 'sbyc'
require 'sequel'

require 'dbagile/contract'
require 'dbagile/errors'
require 'dbagile/ext/object'
require 'dbagile/utils'
require 'dbagile/adapter'
require 'dbagile/core'
require 'dbagile/plugin'
