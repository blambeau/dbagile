require 'dbagile/core/schema/errors'
require 'dbagile/core/schema/schema_object'
require 'dbagile/core/schema/builder'
require 'dbagile/core/schema/computations'
module DbAgile
  module Core
    module Schema

      #
      # Creates a DatabaseSchema instance.
      #
      # Intent of this method is to hide implementation details of this package.
      # It should ALWAYS be used for creating schema instances (no direct accesses
      # to the DatabaseSchema should be made!).
      #
      # @param [Object] optional tracability identifier
      # @return [DatabaseSchema] a database schema
      #
      def new(schema_identifier = nil)
        Schema::DatabaseSchema.new(schema_identifier)
      end
      module_function :new


      ##############################################################################
      ### About schema building 
      ##############################################################################
      
      # 
      # Creates a builder instance
      #
      def builder(schema = nil)
        DbAgile::Core::Schema::Builder.new(schema)
      end
      module_function :builder

      #      
      # Factors a Builder instance ready for loading a yaml schema file
      #
      def yaml_builder(schema = Schema.new)
        DbAgile::Core::Schema::Builder.new(schema)
      end
      module_function :yaml_builder


      ##############################################################################
      ### About Schema and YAML 
      ##############################################################################
      
      #
      # Loads a database schema from a YAML string
      #
      # @param [String] str a YAML schema source
      # @param [DbAgile::Core::Schema::Builder] a builder instance to use to
      #        populate the schema
      # @returns [DbAgile::Core:Schema::DatabaseSchema] the loaded database 
      #          schema
      #
      def yaml_load(str, builder = yaml_builder)
        YAML::each_document(str){|doc|
          builder._natural(doc)
        }
        builder._dump
      rescue SByC::TypeSystem::CoercionError => ex
        raise DbAgile::SchemaSyntaxError, "Syntax error in schema: #{ex.message}"
      end
      module_function :yaml_load
    
      #
      # Loads a schema from a YAML file
      #
      # @param [String|IO] a path name or an IO instance
      # @param [DbAgile::Core::Schema::Builder] a builder instance to use to
      #        populate the schema
      # @returns [DbAgile::Core:Schema::DatabaseSchema] the loaded database 
      #          schema
      #
      def yaml_file_load(path_or_io, builder = yaml_builder)
        case path_or_io
          when String
            File.open(path_or_io, 'r'){|io| yaml_load(io, builder) }
          when IO, File
            yaml_load(path_or_io, builder)
          else 
            raise ArgumentError, "Unable to load schema from #{file}"
        end
      end
      module_function :yaml_file_load
        

      ##############################################################################
      ### About Schema computations
      ##############################################################################
      
      # Resolver block that raises a SchemaConflictError
      DEFAULT_CONFLICT_RESOLVER_BLOCK = lambda{|left,right|
        raise SchemaConflictError.new(left, right)
      }
      
      #
      # Computes a new schema by difference.
      #
      # @param [DbAgile::Core::Schema::DatabaseSchema] left reference schema
      # @param [DbAgile::Core::Schema::DatabaseSchema] right retrieval schema
      # @param [DbAgile::Core::Schema::Builder] builder to use for the operation
      #
      def minus(left, right, 
                builder = DbAgile::Core::Schema::builder)
        Computations::minus(left, right, builder)
      end
      module_function :minus
      
      #
      # Computes a new schema by merging two other schemas.
      #
      # @param [DbAgile::Core::Schema::DatabaseSchema] left schema one
      # @param [DbAgile::Core::Schema::DatabaseSchema] right schema two
      # @param [DbAgile::Core::Schema::Builder] builder to use for merging
      # @param [Proc] conflict_resolver a optional block that resolves merging 
      #               conflicts
      #
      def merge(left, right, 
                builder = DbAgile::Core::Schema::builder, 
                &conflict_resolver)
        if conflict_resolver.nil?
          conflict_resolver = DEFAULT_CONFLICT_RESOLVER_BLOCK
        end
        Computations::merge(left, right, builder, &conflict_resolver)
      end
      module_function :merge
      
    end # module Schema
  end # module Core
end # module DbAgile