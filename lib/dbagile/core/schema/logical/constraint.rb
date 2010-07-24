require 'dbagile/core/schema/logical/constraint/candidate_key'
require 'dbagile/core/schema/logical/constraint/foreign_key'
module DbAgile
  module Core
    class Schema < SchemaObject::Composite
      class Logical < SchemaObject::Composite
        class Constraint < SchemaObject::Part
          
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

        end # class Constraint
      end # module Logical
    end # class Schema
  end # module Core
end # module DbAgile
