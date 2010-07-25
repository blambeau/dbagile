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
  class SchemaSyntaxError < DbAgile::SchemaError; end
  
  # 
  # Raised when a schema is semantically not correct. This error is 
  # abstract, see children classes.
  #
  class SchemaSemanticsError < DbAgile::SchemaError; end
  
  # 
  # Raised when a relation variable has no primary key.
  #
  class PrimaryKeyMissingError < DbAgile::SchemaSemanticsError; end
  
end