require 'time'
require 'tempfile'
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
  #     dba.repository_path  = ...     # your application own repository
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
  def find_repository_path
    if File.exists?("./dbagile.yaml")
      "./dbagile.yaml"
    else
      File.join(ENV['HOME'], '.dbagile/repository.idx')
    end
  end
  module_function :find_repository_path
  
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
  # Creates a new database and returns it.
  #
  # @param [Symbol] name database name
  # @param [Proc] block database block dsl
  # @return [DbAgile::Core::Database] a database instance.
  # 
  def database(name, &block)
    unless block
      default_environment.repository.database(name)
    else
      dsl = DbAgile::Core::IO::DSL.new
      dsl.database(name, &block)
    end
  end
  module_function :database
  
  # Connects to a database and returns a Connection instance
  def connect(uri, options = {}, &block)
    case uri
      when Symbol
        db = database(uri)
        raise NoSuchDatabaseError, "No such database #{uri}" unless db
        db.connect(options)
      when String
        theuri = uri
        db = database(:noname){
          uri theuri
        }
        db.connect(options)
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
require 'dbagile/core'
require 'dbagile/adapter'
require 'dbagile/plugin'
require 'dbagile/environment'
require 'dbagile/command'