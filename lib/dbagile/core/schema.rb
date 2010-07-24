require 'dbagile/core/schema/yaml_methods'
require 'dbagile/core/schema/builder'
require 'dbagile/core/schema/brick'
require 'dbagile/core/schema/named_collection'
require 'dbagile/core/schema/logical'
require 'dbagile/core/schema/physical'
module DbAgile
  module Core
    #
    # Encapsulates the notion of database schema.
    #
    class Schema
      extend(DbAgile::Core::Schema::YAMLMethods)
      
      # Identifier of this schema
      attr_reader :schema_identifier
      
      # Logical schema
      attr_reader :logical
      
      # Physical schema
      attr_reader :physical
      
      # Creates a schema instance
      def initialize(schema_identifier = nil)
        @schema_identifier = schema_identifier
        @logical  = Schema::Logical.new
        @physical = Schema::Physical.new
      end
      
      # Mimics a hash
      def [](name)
        return logical if name == :logical
        return physical if name == :physical
        raise ArgumentError, "No such #{name} on Schema"
      end
      
      # Dumps the schema to YAML
      def to_yaml(opts = {})
        YAML::dump_stream({'logical' => logical}, {'physical' => physical})
      end
      alias :inspect :to_yaml
      
      # Checks if this relvar is empty
      def empty?
        logical.empty? and physical.empty?
      end
          
      # Applies schema minus
      def minus(other, builder = Schema::Builder.new)
        raise ArgumentError, "Schema expected" unless other.kind_of?(Schema)
        unless logical.nil? or logical.brick_empty?
          logical.minus(other.logical, builder)
        end
        unless physical.nil? or physical.brick_empty?
          physical.minus(other.physical, builder)
        end
        builder._dump
      end
      alias :- :minus
      
      # Compares with another attribute
      def ==(other)
        return nil unless other.kind_of?(Schema)
        (logical == other.logical) and (physical == other.physical)
      end
    
      # Yields the block with each relvar in turn
      def each_relvar(&block)
        logical.each(&block)
      end
      
    end # class Schema
  end # module Core
end # module DbAgile