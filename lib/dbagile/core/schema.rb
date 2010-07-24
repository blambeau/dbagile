require 'dbagile/core/schema/schema_object'
require 'dbagile/core/schema/yaml_methods'
require 'dbagile/core/schema/builder'
require 'dbagile/core/schema/computations'
module DbAgile
  module Core
    class Schema < DbAgile::Core::SchemaObject::Composite
      extend(DbAgile::Core::Schema::YAMLMethods)
      
      # Identifier of this schema
      attr_reader :schema_identifier
      
      # Creates a schema instance
      def initialize(schema_identifier = nil)
        @schema_identifier = schema_identifier
        super(
          :logical  => Schema::Logical.new,
          :physical => Schema::Physical.new
        )
      end
      
      def logical
        self[:logical]
      end
      
      def physical
        self[:physical]
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
      
    end # class Schema
  end # module Core
end # module DbAgile