module DbAgile
  module Core
    module Schema
      class Logical
        class Constraint < Schema::Part
          
          # Returns the relation variable on which this key is installed.
          def relation_variable
            parent.parent
          end
        
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

        end # class Constraint
      end # module Logical
    end # module Schema
  end # module Core
end # module DbAgile
require 'dbagile/core/schema/logical/constraint/candidate_key'
require 'dbagile/core/schema/logical/constraint/foreign_key'
