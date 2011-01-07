module DbAgile
  
  # Raised when a backend name is not valid
  class InvalidBackendName < DbAgile::Error; end
  
  # Raised when a backend cannot be found
  class NoSuchBackendError < DbAgile::Error; end
  
  # Raised when a database name is not valid
  class InvalidDatabaseName < DbAgile::Error; end
  
  # Raised when a database URI is not valid
  class InvalidDatabaseUri < DbAgile::Error; end
  
  # Raised when a command does not exists (dba command line tool)
  class NoSuchCommandError < DbAgile::Error; end
  
  # Raised when the repository seems corrupted
  class CorruptedRepositoryError < DbAgile::Error; end
  
  # Raised when a database cannot be found
  class NoSuchDatabaseError < DbAgile::Error; end

  # Raised when a database name is already used (on add)
  class DatabaseNameConflictError < DbAgile::Error; end

  # Raised when no default database is set
  class NoDefaultDatabaseError < DbAgile::Error; end
  
  # Raised when input parsing of data fails for some reason
  class InvalidFormatError < DbAgile::Error; end
  
  # Raised when usage of schema files fails because they are not installed
  class NoSchemaFilesError < DbAgile::Error; end
  
  # Raised when a candidate key cannot be infered from a given tuple
  class CandidateKeyNotFoundError < DbAgile::Error; end
  
end # module DbAgile