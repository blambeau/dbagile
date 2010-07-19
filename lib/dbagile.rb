module DbAgile
  
  # Version of the DbAgile interface
  VERSION = "0.0.1".freeze
  
  # 
  # Builds a DbAgile::Command::API instance and yields the block with the
  # api instance.
  #
  # A fresh new default environement is created if no one is given.
  #
  # Example
  #   DbAgile::dba do |dba|
  #     # Override environment default values (~/.dbagile, ...)
  #     dba.config_file_path  = ...    # your application own config file
  #     dba.history_file_path = nil    # no history
  #     dba.output_buffer     = ...    # keep messages in any object supporting :<< (STDOUT by default)
  # 
  #     # Start using dbagile commands
  #     dba.export %w{--csv --type-safe contacts}  # each line pushed in buffer
  #     dba.export %w{--ruby contacts}             # each record pushed as a Hash in buffer
  # end
  #
  def dba(environment = nil)
    env = environment || ::DbAgile::Environment.new
    api = DbAgile::Command::API.new(env)
    yield(api)
  end
  module_function :dba
  
  # Returns the default environment to use.
  def default_environment
    @environment ||= ::DbAgile::Environment.new
  end
  module_function :default_environment

  # Sets the default environment to use.
  def default_environment=(env)
    @environment = env
  end
  module_function :default_environment=
  
  #
  # If a block is given, creates a new configuration, save it in environment 
  # and returns the block. Otherwise, returns a confguration by name.
  #
  # @param [Symbol] name configuration name
  # @param [Proc] block configuration block dsl (optional)
  # @return [DbAgile::Core::Configuration] a database configuration instance.
  # 
  def config(name, &block)
    default_environment.with_config_file(true) do |config_file|
      if block_given?
        config = DbAgile::Core::Configuration.new(name, &block)
        config_file << config
        config
      else
        config_file.config(name)
      end
    end
  end
  module_function :config
  
  # Connects to a database and returns a Database instance
  def connect(uri, options = {}, &block)
    case uri
      when Symbol
        config = config(uri)
        raise NoSuchConfigError, "No such configuration #{uri}" unless config
        config.connect(options)
      when String
        DbAgile::Core::Configuration.new.connect(uri, options)
      else
        raise ArgumentError, "Unable to use #{uri} to connect a database"
    end
  end
  module_function :connect
  
end # module DbAgile

require 'rubygems'
gem "sbyc", ">= 0.1.3"
gem "sequel", ">= 3.8.0"
require 'sbyc'
require 'sequel'

require 'dbagile/errors'
require 'dbagile/contract'
require 'dbagile/tools'
require 'dbagile/ext/object'
require 'dbagile/io'
require 'dbagile/adapter'
require 'dbagile/core'
require 'dbagile/plugin'
require 'dbagile/environment'
require 'dbagile/command'