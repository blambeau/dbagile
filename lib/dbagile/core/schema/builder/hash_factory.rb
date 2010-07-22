module DbAgile
  module Core
    class Schema
      class Builder
        module HashFactory

          # Builds a relvar
          def build_relvar(name)
            {}
          end
        
          # Builds a heading
          def build_heading
            {}
          end
        
          # Builds an attribute
          def build_attribute(name, definition)
            attribute_def_hash!(definition)
          end
        
          # Builds a constraint collection
          def build_constraints
            {}
          end
        
          # Builds a constraint
          def build_constraint(name, definition)
            constraint_def_hash!(definition)
          end
        
          # Builds an index collection
          def build_indexes
            {}
          end
        
          # Builds an index
          def build_index(name, definition)
            index_def_hash!(definition)
          end

        end # module HashFactory
      end # class Builder
    end # class Schema
  end # module Core
end # module DbAgile
