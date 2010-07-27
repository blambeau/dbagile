module DbAgile
  module Core
    module Schema
      class Logical
        class Constraint < Schema::Part
          
          ############################################################################
          ### Constraint factory
          ############################################################################
        
          # Builds a constraint
          def self.factor(name, definition)
            case kind = definition[:type]
              when :primary_key, :candidate_key, :key
                Schema::Logical::CandidateKey.new(name, definition)
              when :foreign_key
                Schema::Logical::ForeignKey.new(name, definition)
              else 
                raise ArgumentError, "Unexpected constraint kind #{kind}"
            end
          end

          ############################################################################
          ### Query interface
          ############################################################################
          
          # Returns true if this constraint is a candidate key (including a primary 
          # key)
          def candidate_key?
            self.kind_of?(Logical::CandidateKey)
          end
          
          # Returns true if this constraint is a primary key, false otherwise
          def primary_key?
            candidate_key? and primary?
          end
        
          # Returns true if this constraint is a foreign key
          def foreign_key?
            self.kind_of?(Logical::ForeignKey)
          end
          
          ############################################################################
          ### Dependency control
          ############################################################################
          
          # @see DbAgile::Core::Schema::SchemaObject
          def dependencies(include_parent = false)
            include_parent ? [ parent ] : false
          end
          
        end # class Constraint
      end # module Logical
    end # module Schema
  end # module Core
end # module DbAgile
require 'dbagile/core/schema/logical/constraint/candidate_key'
require 'dbagile/core/schema/logical/constraint/foreign_key'
