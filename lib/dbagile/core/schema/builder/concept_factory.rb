module DbAgile
  module Core
    class Schema
      class Builder
        module ConceptFactory

          # Builds a relvar
          def build_relvar(name)
            Schema::Logical::Relvar.new(name)
          end
        
          # Builds a heading
          def build_heading
            Schema::Logical::Heading.new
          end
        
          # Builds an attribute
          def build_attribute(name, definition)
            Schema::Logical::Attribute.new(name, definition)
          end
        
          # Builds a constraint collection
          def build_constraints
            {}
          end
        
          # Builds a constraint
          def build_constraint(name, definition)
            case kind = definition[:type]
              when :primary_key, :candidate_key, :key
                Schema::Logical::Constraint::CandidateKey.new(name, definition)
              when :foreign_key
                Schema::Logical::Constraint::ForeignKey.new(name, definition)
              else 
                raise ArgumentError, "Unexpected constraint kind #{kind}"
            end
          end
        
          # Builds an index collection
          def build_indexes
            {}
          end
        
          # Builds an index
          def build_index(name, definition)
            Schema::Physical::Index.new(name, definition)
          end

        end # module ConceptFactory
      end # class Builder
    end # class Schema
  end # module Core
end # module DbAgile
