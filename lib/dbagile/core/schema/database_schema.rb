module DbAgile
  module Core
    module Schema
      class DatabaseSchema < Schema::Composite
        include Enumerable
        alias :each :visit
      
        # Identifier of this schema
        attr_accessor :schema_identifier
      
        # Creates a schema instance
        def initialize(schema_identifier = nil, parts = _default_parts)
          @schema_identifier = schema_identifier
          super(parts)
          @insert_order = [:logical, :physical]
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
        
        # Strips this schema
        def _strip!
          logical._strip!
          self
        end
        
        ############################################################################
        ### SchemaObject
        ############################################################################
        
        # Returns an array with part dependencies
        def dependencies(include_parent = false)
          []
        end
          
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
      

        # Returns a yaml string
        def yaml_display(env, 
                         options = {}, 
                         colors = DbAgile::Core::Schema::STATUS_TO_COLOR, 
                         indent = 0)
          env.display("---\nlogical:")
          logical.yaml_display(env, options, colors, indent + 1)
          env.display("\n---\nphysical:")
          physical.yaml_display(env, options, colors, indent + 1)
        end
        
        ############################################################################
        ### Computations
        ############################################################################
          
        # Applies schema checking and raises a SchemaSemanticsError if something is wrong.
        def check!(raise_on_error = true)
          errors = SchemaSemanticsError.new(self)
          _semantics_check(SchemaSemanticsError, errors)
          if raise_on_error and not(errors.empty?)
            raise errors
          else
            errors
          end
        end
        
        # Convenient method for <code>schema.check!(false).empty?</code>
        def looks_valid?
          check!(false).empty?
        end
      
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
        
        # Applies schema filtering
        def filter(options = {}, &filter_block)
          Schema::filter(self, options, &filter_block)
        end
        
        # Applies schema splitting
        def split(options = {}, &split_block)
          Schema::split(self, options, &split_block)
        end
        
      end # class DatabaseSchema
    end # module Schema
  end # module Core
end # module DbAgile
require 'dbagile/core/schema/logical'
require 'dbagile/core/schema/physical'
