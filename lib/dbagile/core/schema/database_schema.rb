module DbAgile
  module Core
    module Schema
      class DatabaseSchema < Schema::Composite
        include Enumerable
        alias :each :visit
      
        # Identifier of this schema
        attr_reader :schema_identifier
      
        # Creates a schema instance
        def initialize(schema_identifier = nil, parts = _default_parts)
          @schema_identifier = schema_identifier
          super(parts)
        end

        
        ############################################################################
        ### Private interface
        ############################################################################
          
        # @see DbAgile::Core::Schema::Composite#_install_eigenclass_methods?
        def _install_eigenclass_methods?
          true
        end
      
        # @see DbAgile::Core::Schema::Composite#_default_parts
        def _default_parts
          {:logical  => Schema::Logical.new,
           :physical => Schema::Physical.new}
        end

        
        ############################################################################
        ### SchemaObject
        ############################################################################
          
        # Overrided to return self.
        def schema
          self
        end
      
        # @see DbAgile::Core::Schema::SchemaObject
        def dup
          DatabaseSchema.new(schema_identifier, _dup_parts)
        end

        
        ############################################################################
        ### IO
        ############################################################################
          
        # Dumps the schema to YAML
        def to_yaml(opts = {})
          YAML::dump_stream({'logical' => logical}, {'physical' => physical})
        end
        alias :inspect :to_yaml
      

        ############################################################################
        ### Computations
        ############################################################################
          
        # Applies schema minus
        def minus(other)
          Schema::minus(self, other)
        end
        alias :- :minus
      
        # Applies schema merging
        def merge(other)
          Schema::merge(self, other)
        end
        alias :+ :merge
        
        # Applies schema checking and raises a SchemaSemanticsError if something
        # is wrong.
        def check!(raise_on_error = true)
          errors = SchemaSemanticsError.new(self)
          _semantics_check(SchemaSemanticsError, errors)
          if raise_on_error and not(errors.empty?)
            raise errors
          else
            errors
          end
        end
      
      end # class DatabaseSchema
    end # module Schema
  end # module Core
end # module DbAgile
require 'dbagile/core/schema/logical'
require 'dbagile/core/schema/physical'
