require 'dbagile/core/schema/errors'
require 'dbagile/core/schema/robustness'
require 'dbagile/core/schema/schema_object'
require 'dbagile/core/schema/builder'
require 'dbagile/core/schema/computations'
require 'dbagile/core/schema/migrate'
module DbAgile
  module Core
    module Schema
      extend(Schema::Robustness)

      # An empty schema
      EMPTY_SCHEMA = Schema::DatabaseSchema.new

      # Status of objects that need to be created (on left)
      TO_CREATE = :to_create

      # Status of objects that need to be dropped (on left)
      TO_DROP   = :to_drop

      # Status of objects that need to be altered (on left)
      TO_ALTER  = :to_alter

      # Status of objects that need not being altered in any way
      NO_CHANGE = :no_change
      
      # Status of objects that have been created
      CREATED   = :created

      # Status of objects that have been dropped
      DROPPED   = :dropped

      # Status of objects that have been altered
      ALTERED   = :altered

      # Status of objects whose migrayion is currently pending
      PENDING   = :pending

      # Status of objects whose migration has been defered
      DEFERED   = :defered
      
      STATUS_TO_COLOR = {
        TO_CREATE => :green,
        TO_DROP   => :red,
        TO_ALTER  => :cyan,
        NO_CHANGE => :black,
        #
        CREATED   => :green,
        DROPPED   => :green,
        ALTERED   => :green,
        PENDING   => :red,
        DEFERED   => :red
      }

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
        schema!(left, :left, caller)
        schema!(right, :right, caller)
        builder!(builder, :builder, caller)
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
        schema!(left, :left, caller)
        schema!(right, :right, caller)
        builder!(builder, :builder, caller)
        if conflict_resolver.nil?
          conflict_resolver = DEFAULT_CONFLICT_RESOLVER_BLOCK
        end
        Computations::merge(left, right, builder, &conflict_resolver)
      end
      module_function :merge
      
      #
      # Filters a schema according to a block
      #
      def filter(schema, options = {}, 
                 builder = DbAgile::Core::Schema::builder, 
                 &filter_block)
        schema!(schema, :schema, caller)
        hash!(options, :options, caller)
        builder!(builder, :builder, caller)
        options = Computations::Filter::DEFAULT_OPTIONS.merge(options)
        filtered = Schema::Computations::filter(schema, options, builder, &filter_block)._strip!
        if options[:identifier]
          filtered.schema_identifier = options[:identifier]
        end
        filtered
      end
      module_function :filter
        
      #
      # Splits a schema according to a block
      #
      def split(schema, options = {}, &filter_block)
        schema!(schema, :schema, caller)
        hash!(options, :options, caller)
        options = Computations::Split::DEFAULT_OPTIONS.merge(options)
        Schema::Computations::split(schema, options, &filter_block)
      end
      module_function :split
      
      ##############################################################################
      ### About Schema scripts
      ##############################################################################
      
      #
      # Computes and returns a list of abstract operations to perform on a database
      # given a annotated schema (typically, the result of a merge operation)
      #
      # @param [DbAgile::Core::Schema::DatabaseSchema] schema an annotated schema
      # @param [Hash] options staging options
      # @return [Migrate::AbstractScript] a list of abstract operations
      #
      def stage_script(schema, options = Migrate::Stager::DEFAULT_OPTIONS)
        Migrate::Stager.new.run(schema, options)
      end
      module_function :stage_script
      
      # 
      # Computes a create abstract script for a given schema.
      #
      # @param [DbAgile::Core::Schema::DatabaseSchema] any valid schema
      # @return [Migrate::AbstractScript] a list of abstract operations
      #
      def create_script(schema)
        stage_script(EMPTY_SCHEMA + schema)
      end
      module_function :create_script
      
      # 
      # Computes a drop abstract script for a given schema.
      #
      # @param [DbAgile::Core::Schema::DatabaseSchema] any valid schema
      # @return [Migrate::AbstractScript] a list of abstract operations
      #
      def drop_script(schema)
        stage_script(schema + EMPTY_SCHEMA)
      end
      module_function :drop_script
      
    end # module Schema
  end # module Core
end # module DbAgile