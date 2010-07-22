require 'dbagile/core/schema/yaml_methods'
require 'dbagile/core/schema/builder'
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
      def initialize(logical = {}, physical = {})
        @logical, @physical = logical, physical
      end
      
      # Dumps the schema to YAML
      def to_yaml(opts = {})
        ls = Schema::Coercion::unsymbolize_hash(logical)
        ps = Schema::Coercion::unsymbolize_hash(physical)
        if ps['indexes']
          ps['indexes'] = Schema::Coercion::unsymbolize_hash(ps['indexes'])
        end
        YAML::dump_stream(
          {'logical'  => ls}, 
          {'physical' => ps}
        )
      end
      alias :inspect :to_yaml
      
    end # class Schema
  end # module Core
end # module DbAgile