require 'dbagile/core/schema/yaml_methods'
require 'dbagile/core/schema/builder'
require 'dbagile/core/schema/relvar'
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
      
      # Dumps the schema as a YAML file
      def yaml_unload(buffer = "")
        self.class.yaml_unload(self)
      end
      alias :inspect :yaml_unload
      
    end # class Schema
  end # module Core
end # module DbAgile