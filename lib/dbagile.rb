module DbAgile
  
  # Version of the DbAgile interface
  VERSION = "0.0.1".freeze
  
  # 
  # Builds a DbAgile::Command::API instance and yields the block with the
  # environment and the api instance.
  #
  # A fresh new default environement is created if no one is given.
  #
  # Example
  #   DbAgile::command do |env, dbagile|
  #     # Overrides environment default values (~/.dbagile, ...)
  #     env.config_file_path = ...
  #     env.output_buffer = ...
  #
  #     # Starts using dbagile commands
  #     dbagile.export "--csv people"
  #   end
  #
  def command(environment = nil)
    env = environment || ::DbAgile::Environment.new
    api = DbAgile::Command::API.new(env)
    yield(env, api)
  end
  module_function :command
  
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
        raise UnknownConfigError, "No such configuration #{uri}" unless config
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
gem "sbyc", ">= 0.1.2"
gem "sequel", ">= 3.8.0"
require 'sbyc'
require 'sequel'

require 'dbagile/contract'
require 'dbagile/errors'
require 'dbagile/ext/object'
require 'dbagile/io'
require 'dbagile/adapter'
require 'dbagile/core'
require 'dbagile/plugin'
require 'dbagile/environment'
require 'dbagile/command'