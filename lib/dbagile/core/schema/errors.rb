module DbAgile

  # Raised when something goes wrong with a schema
  class SchemaError < DbAgile::Error; end

  #
  # Raised when something goes wrong with a schema during a builder 
  # execution.
  #
  # As schema parsing is often made on YAML files, any error at builder
  # stage is considered a syntax error. However, it includes schema
  # type checking, which is not that syntactic!
  #
  # Syntax error when parsing #{schema_file}: #{cause.message}
  #
  class SchemaSyntaxError < DbAgile::SchemaError; end
  
  # 
  # Raised when a schema is semantically not correct. This error is 
  # abstract, see children classes.
  #
  class SchemaSemanticsError < DbAgile::SchemaError; end
  
  # 
  # Raised when something goes really wrong with a schema. This certainly
  # indicates a bug inside DbAgile, please report!
  #
  # Something wrong happened in DbAgile when using your schema. Please report 
  # the error to developers:
  # #{cause.message}
  # #{cause.backtrace}
  #
  class SchemaInternalError < DbAgile::SchemaError; end
  
  # 
  # Raised when a relation variable has no primary key.
  #
  # Relation variable #{relvar.name} has no primary key. Relations should be sets, 
  # not bags! A primary key ensures this certainly sound fact!
  #
  class MissingPrimaryKeyError < DbAgile::SchemaSemanticsError; end
  
end