require 'time'
require 'date'
require 'yaml'
require 'rubygems'
gem "sbyc", ">= 0.1.4"
gem "sequel", ">= 3.8.0"
require 'sbyc'
require 'sequel'
module DbAgile
  
  # Version of the DbAgile interface
  VERSION = "0.0.1".freeze
  
  # Domains recognized as valid domains inside a SQL database
  RECOGNIZED_DOMAINS = [
    ::SByC::TypeSystem::Ruby::Boolean,
    TrueClass, FalseClass, 
    String, 
    Fixnum, Bignum, Integer,
    Float,
    Time, 
    Date
  ]
  
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
  #     dba.bulk_export %w{--csv --type-safe contacts}  # each line pushed in buffer
  #     dba.bulk_export %w{--ruby contacts}             # each record pushed as a Hash in buffer
  # end
  #
  def dba(environment = nil)
    env = environment || ::DbAgile::Environment.new
    api = DbAgile::Command::API.new(env)
    yield(api)
  end
  module_function :dba
  
  # Finds 
  def find_config_file_path
    if File.exists?("./dbagile.cfg")
      "./dbagile.cfg"
    else
      File.join(ENV['HOME'], '.dbagile')
    end
  end
  module_function :find_config_file_path
  
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
  # Creates a new configuration and returns it.
  #
  # @param [Symbol] name configuration name
  # @param [Proc] block configuration block dsl
  # @return [DbAgile::Core::Configuration] a database configuration instance.
  # 
  def config(name, &block)
    unless block
      default_environment.config_file.config(name)
    else
      dsl = DbAgile::Core::Configuration::DSL.new
      dsl.config(name, &block)
    end
  end
  module_function :config
  
  # Connects to a database and returns a Connection instance
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
gem "sbyc", ">= 0.1.4"
gem "sequel", ">= 3.8.0"
gem 'highline', '>= 1.5.2'
require 'sbyc'
require 'sequel'
require 'highline'

require 'dbagile/errors'
require 'dbagile/contract'
require 'dbagile/tools'
require 'dbagile/io'
require 'dbagile/adapter'
require 'dbagile/core'
require 'dbagile/plugin'
require 'dbagile/environment'
require 'dbagile/command'