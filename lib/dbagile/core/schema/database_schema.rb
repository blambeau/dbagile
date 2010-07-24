module DbAgile
  module Core
    module Schema
      class DatabaseSchema < Schema::Composite
      
        # Identifier of this schema
        attr_reader :schema_identifier
      
        # Creates a schema instance
        def initialize(schema_identifier = nil)
          @schema_identifier = schema_identifier
          super(_default_parts)
        end
      
        # @see DbAgile::Core::Schema::Composite#_install_eigenclass_methods?
        def _install_eigenclass_methods?
          true
        end
      
        # @see DbAgile::Core::Schema::Composite#_default_parts
        def _default_parts
          {:logical  => Schema::Logical.new,
           :physical => Schema::Physical.new}
        end
        
        # Dumps the schema to YAML
        def to_yaml(opts = {})
          YAML::dump_stream({'logical' => logical}, {'physical' => physical})
        end
        alias :inspect :to_yaml
      
        # Applies schema minus
        def minus(other, builder = Schema::Builder.new)
          Schema::Computations::minus(self.logical, other.logical, builder)
          Schema::Computations::minus(self.physical, other.physical, builder)
          builder._dump
        end
        alias :- :minus
      
        # Yields the block with each relvar in turn
        def each_relvar(&block)
          logical.each(&block)
        end
      
      end # class DatabaseSchema
    end # module Schema
  end # module Core
end # module DbAgile
require 'dbagile/core/schema/logical'
require 'dbagile/core/schema/physical'
