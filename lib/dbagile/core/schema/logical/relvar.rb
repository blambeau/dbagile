module DbAgile
  module Core
    class Schema
      class Logical < Schema::Brick
        class Relvar < Schema::Brick
          include Schema::NamedCollection
          
          # Relvar name
          attr_reader :name
        
          # Creates a relation variable instance
          def initialize(name)
            @name = name.to_s.to_sym
            __initialize_named_collection(
              :heading     => Schema::Logical::Heading.new,
              :constraints => Schema::Logical::Constraints.new
            )
          end
          
          # Returns relvar heading
          def heading
            self[:heading]
          end
        
          # Returns relvar constraints
          def constraints
            self[:constraints]
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
            (name == other.name) and (sub_bricks == other.sub_bricks)
          end
        
          # Returns an hash code
          def hash
            [ name, heading, constraints ].hash
          end
          
          # Duplicates this attribute
          def dup
            dup = Logical::Relvar.new(name)
            dup[:heading] = heading.dup
            dup[:constraints] = constraints.dup
            dup
          end
        
        end # class Relvar
      end # module Logical
    end # class Schema
  end # module Core
end # module DbAgile
