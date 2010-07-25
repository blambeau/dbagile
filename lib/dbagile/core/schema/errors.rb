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
  # Raised when a schema is semantically not correct. This error is 
  # abstract, see children classes.
  #
  class SchemaSemanticsError < DbAgile::SchemaError
    
    # Involved schema object
    attr_reader :schema_object
    
    # Creates an error instance
    def initialize(*args)
      if args.first.kind_of?(DbAgile::Core::Schema::SchemaObject)
        @schema_object = args.shift 
      end
      super(*args)
    end
    
  end # class SchemaSemanticsError
  
  # 
  # Raised when an operation on schemas fails because of conflicts (typically
  # a merge operation without resolver block)
  #
  # Database schema conflict between #{left} and #{right}
  #
  class SchemaConflictError < DbAgile::SchemaSemanticsError 
    
    # Left schema object
    attr_reader :left
    
    # Right schema object
    attr_reader :right
    
    # Creates an error instance
    def initialize(left, right)
      @left, @right = left, right
      super(left.parent)
    end
    
  end # class SchemaConflictError
  
  # 
  # Raised when a relation variable has no primary key.
  #
  # Relation variable #{relvar.name} has no primary key. Relations should be sets, 
  # not bags! A primary key ensures this certainly sound fact!
  #
  class MissingPrimaryKeyError < DbAgile::SchemaSemanticsError; end
  
end