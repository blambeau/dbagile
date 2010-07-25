module DbAgile

  # Raised when something goes wrong with a schema
  class SchemaError < DbAgile::Error; end

  # Raised when something goes wrong with a schema during a builder
  # execution.
  class InvalidSchemaError < DbAgile::SchemaError; end
  
end