module DbAgile
  module Core
    module Schema
      class Logical
        class Relvar < Schema::Composite
          
          # Relvar name
          attr_reader :name
        
          # Creates a relation variable instance
          def initialize(name, parts = _default_parts)
            @name = name.to_s.to_sym
            super(parts)
          end
          
          ############################################################################
          ### Private interface
          ############################################################################
          
          # @see DbAgile::Core::Schema::Composite#_install_eigenclass_methods?
          def _install_eigenclass_methods?
            true
          end
        
          # Creates default parts
          def _default_parts
            {:heading     => Schema::Logical::Heading.new,
             :constraints => Schema::Logical::Constraints.new}
          end
        
          # Makes a sanity check on the part
          def _sanity_check(schema)
            raise SchemaInternalError, "No name provided on #{self}" if name.nil?
            super(schema)
          end
        
          # Checks this composite's semantics and collects errors inside buffer
          def _semantics_check(clazz, buffer)
            if constraints.primary_key.nil?
              buffer.add_error(self, clazz::MissingPrimaryKey)
            end
            super(clazz, buffer)
          end
      
          ############################################################################
          ### Pseudo-private SchemaObject interface
          ############################################################################
          
          # Returns the arguments to pass to builder handler
          def builder_args
            [ name ]
          end

          ############################################################################
          ### Equality and hash code
          ############################################################################
        
          # Compares with another attribute
          def look_same_as?(other)
            return nil unless other.kind_of?(Relvar)
            return false unless name == other.name
            super(other)
          end
        
          # Duplicates this attribute
          def dup
            Logical::Relvar.new(name, :heading => heading.dup, :constraints => constraints.dup)
          end
          
          # Returns a string representation
          def to_s
            "#{DbAgile::RubyTools::unqualified_class_name(self.class)}: #{name}"
          end
          
          private :_default_parts
        end # class Relvar
      end # module Logical
    end # module Schema
  end # module Core
end # module DbAgile
