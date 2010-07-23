require 'dbagile/core/schema/yaml_methods'
require 'dbagile/core/schema/builder'
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
      
      # Logical schema
      attr_reader :logical
      
      # Physical schema
      attr_reader :physical
      
      # Creates a schema instance
      def initialize
        @logical  = Schema::NamedCollection.new(:logical)
        @physical = Schema::NamedCollection.new(:physical)
      end
      
      # Mimics a hash
      def [](name)
        case name
          when :logical
            self.logical
          when :physical
            self.physical
          else
            raise ArgumentError, "No such #{name} on Schema"
        end
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
        unless logical.nil? or logical.empty?
          logical.minus(other.logical, builder)
        end
        unless physical.nil? or physical.empty?
          physical.minus(other.physical, builder)
        end
        builder._dump
      end
      alias :- :minus
      
      # Removes empty relvars
      def strip!
        logical.delete_if{|k, v| v.empty?}
        physical.delete_if{|k, v| v.empty?}
        self
      end
      
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