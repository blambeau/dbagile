module DbAgile
  module Core
    class Schema < SchemaObject::Composite
      class Logical < SchemaObject::Composite
        class Relvar < SchemaObject::Composite
          
          # Relvar name
          attr_reader :name
        
          # Creates a relation variable instance
          def initialize(name, parts = _default_parts)
            @name = name.to_s.to_sym
            super(parts)
          end
          
          # @see DbAgile::Core::SchemaObject::Composite#_install_eigenclass_methods?
          def _install_eigenclass_methods?
            true
          end
        
          # Creates default parts
          def _default_parts
            {:heading     => Schema::Logical::Heading.new,
             :constraints => Schema::Logical::Constraints.new}
          end
        
          # Yields the block with each attribute 
          def each_attribute(&block)
            heading.each_attribute(&block)
          end
          
          # Returns the relation variable primary key
          def primary_key
            constraints.each{|c|
              return c if c.kind_of?(Logical::Constraint::CandidateKey) and c.primary?
            }
            raise InvalidSchemaError, "Relation variable #{name} has no primary key!"
          end
          
          # Yiels the block with each foreign key
          def each_foreign_key(&block)
            constraints.select{|c|
              c.kind_of?(Logical::Constraint::ForeignKey)
            }.each(&block)
          end
          
          ############################################################################
          ### Equality and hash code
          ############################################################################
        
          # Compares with another attribute
          def ==(other)
            return nil unless other.kind_of?(Relvar)
            return false unless name == other.name
            super
          end
        
          # Returns an hash code
          def hash
            [ name, heading, constraints ].hash
          end
          
          # Duplicates this attribute
          def dup
            Logical::Relvar.new(name, :heading => heading.dup, :constraints => constraints.dup)
          end
          
          private :_default_parts
        end # class Relvar
      end # module Logical
    end # class Schema
  end # module Core
end # module DbAgile
