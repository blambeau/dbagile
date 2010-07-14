module DbAgile
  # Main class of all DbAgile errors
  class Error < StandardError; end
  
  # Raised when a command does not exists (dba command line tool)
  class NoSuchCommandError < DbAgile::Error; end
  
  # Raised when the configuration file seems corrupted
  class CorruptedConfigFileError < DbAgile::Error; end
  
  # Raised when the configuration file cannot be found
  class NoConfigFileError < DbAgile::Error; end
  
  # Raised when a configuration cannot be found
  class UnknownConfigError < DbAgile::Error; end

  # Raised when no default configuration is set
  class NoDefaultConfigError < DbAgile::Error; end
  
end