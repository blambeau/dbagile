require 'dbagile/core/schema/logical/constraint/candidate_key'
require 'dbagile/core/schema/logical/constraint/foreign_key'
module DbAgile
  module Core
    class Schema
      class Logical < Schema::Brick
        class Constraint < Schema::Brick
          
          ############################################################################
          ### Constraint factory
          ############################################################################
        
          # Builds a constraint
          def self.factor(name, definition)
            case kind = definition[:type]
              when :primary_key, :candidate_key, :key
                Schema::Logical::Constraint::CandidateKey.new(name, definition)
              when :foreign_key
                Schema::Logical::Constraint::ForeignKey.new(name, definition)
              else 
                raise ArgumentError, "Unexpected constraint kind #{kind}"
            end
          end

          ############################################################################
          ### Instance variables and initialization
          ############################################################################
        
          # Candidate key name
          attr_reader :name
        
          # Candidate key definition
          attr_reader :definition
        
          def initialize(name, definition)
            @name = name
            @definition = definition
          end
            
          ############################################################################
          ### DbAgile::Core::Schema::Brick
          ############################################################################
        
          # @see DbAgile::Core::Schema::Brick#brick_composite?
          def brick_composite?
            false
          end
        
          ############################################################################
          ### Equality and hash code
          ############################################################################
        
          # Compares with another index
          def ==(other)
            return nil unless other.kind_of?(self.class)
            (name == other.name) and (definition == other.definition)
          end
          
          # Returns an hash code
          def hash
            [ name, definition ].hash
          end
          
          # Duplicates this index
          def dup
            self.class.new(name, definition.dup)
          end
        
        end # class Constraint
      end # module Logical
    end # class Schema
  end # module Core
end # module DbAgile
