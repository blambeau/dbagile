module DbAgile
  module Core
    module Schema
      class Logical
        class Constraints < Schema::Composite
          
          # Returns the primary key
          def primary_key
            each_part{|c|
              return c if c.kind_of?(Logical::CandidateKey) and c.primary?
            }
            nil
          end
          
          # Returns a constraint by name
          def constraint_key_name(name)
            self[name]
          end
          
        end # class Constraints
      end # class Logical
    end # module Schema
  end # module Core
end # module DbAgile