require 'dbagile/core/schema/yaml_methods'
module DbAgile
  module Core
    #
    # Encapsulates the notion of database schema.
    #
    class Schema
      extend(DbAgile::Core::Schema::YAMLMethods)
      
      # Creates a schema instance
      def initialize(logical, physical)
        @logical, @physical = logical, physical
      end
      
    end # class Schema
  end # module Core
end # module DbAgile