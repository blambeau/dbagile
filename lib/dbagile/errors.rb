module DbAgile
  
  # Main class of all DbAgile errors
  class Error < StandardError; end
  
  # Raised when something goes really wrong (a bug, typically)
  class InternalError < DbAgile::Error; end
  
  # Some internal assumption failed
  class AssumptionFailedError < DbAgile::InternalError; end
  
  # Raised when a configuration name is not valid
  class InvalidConfigurationName < DbAgile::Error; end
  
  # Raised when a database URI is not valid
  class InvalidDatabaseUri < DbAgile::Error; end
  
  # Raised when a command does not exists (dba command line tool)
  class NoSuchCommandError < DbAgile::Error; end
  
  # Raised when the configuration file seems corrupted
  class CorruptedConfigFileError < DbAgile::Error; end
  
  # Raised when the configuration file cannot be found
  class NoConfigFileError < DbAgile::Error; end
  
  # Raised when a configuration cannot be found
  class NoSuchConfigError < DbAgile::Error; end

  # Raised when a configuration name is already used (on add)
  class ConfigNameConflictError < DbAgile::Error; end

  # Raised when no default configuration is set
  class NoDefaultConfigError < DbAgile::Error; end
  
  # Raised when input parsing of data fails for some reason
  class InvalidFormatError < DbAgile::Error; end
  
  # Raised when usage of schema files fails because they are not installed
  class NoSchemaFilesError < DbAgile::Error; end
  
end # module DbAgile