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
        
          ############################################################################
          ### Pseudo-private SchemaObject interface
          ############################################################################
          
          # Returns the arguments to pass to builder handler
          def builder_args
            [ name ]
          end

          ############################################################################
          ### Public check interface
          ############################################################################
          
          # Checks this composite's semantics and collects errors inside buffer
          def semantical_errors
            buffer = super
            buffer << MissingPrimaryKeyError.new(self) if primary_key(false).nil?
            buffer
          end
      
          ############################################################################
          ### Public navigation interface
          ############################################################################
          public 
          
          # Yields the block with each attribute 
          def each_attribute(&block)
            heading.each_attribute(&block)
          end
          
          # Returns the relation variable primary key
          def primary_key(raise_if_unfound = true)
            constraints.each_part{|c|
              return c if c.kind_of?(Logical::CandidateKey) and c.primary?
            }
            if raise_if_unfound
              raise MissingPrimaryKeyError.new(self)
            else
              nil
            end
          end
          
          # Yiels the block with each foreign key
          def each_foreign_key(&block)
            constraints.select{|c|
              c.kind_of?(Logical::ForeignKey)
            }.each(&block)
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
        
          # Returns an hash code
          def hash
            [ name, heading, constraints ].hash
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
