require 'dbagile/loader'
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
    environment ||= default_environment
    dba = DbAgile::Command::API.new(environment)
    if block_given?
      yield(dba)
    else
      dba
    end
  end
  module_function :dba
  
  #
  # Builds a default environment instance.
  #
  # @see DbAgile::Core::Repository.default
  #
  def default_environment
    DbAgile::Environment.default
  end
  module_function :default_environment

end # module DbAgile
require 'dbagile/robustness'
require 'dbagile/errors'
require 'dbagile/environment'
require 'dbagile/contract'
require 'dbagile/tools'
require 'dbagile/io'
require 'dbagile/core'
require 'dbagile/adapter'
require 'dbagile/plugin'
require 'dbagile/command'