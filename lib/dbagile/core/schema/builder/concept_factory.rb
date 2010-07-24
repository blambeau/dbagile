module DbAgile
  module Core
    module Schema
      class Builder
        module ConceptFactory

          # Builds a logical schema
          def build_schema(identifier)
            Schema.new(identifier)
          end
          
          # Builds a logical schema
          def build_logical
            Schema::Logical.new
          end
          
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
            Schema::Logical::Constraint.new
          end
        
          # Builds a constraint
          def build_constraint(name, definition)
            Schema::Logical::Constraint::factor(name, definition)
          end
        
          # Builds a physical schema
          def build_physical
            Schema::Physical.new
          end
          
          # Builds an index collection
          def build_indexes
            Schema::Physical::Indexes.new
          end
        
          # Builds an index
          def build_index(name, definition)
            Schema::Physical::Index.new(name, definition)
          end

        end # module ConceptFactory
      end # class Builder
    end # module Schema
  end # module Core
end # module DbAgile
