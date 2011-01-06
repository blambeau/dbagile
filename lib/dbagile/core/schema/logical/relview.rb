module DbAgile
  module Core
    module Schema
      class Logical
        class Relview < Schema::Part
        
          ############################################################################
          ### Dependency control
          ############################################################################
          
          # @see DbAgile::Core::Schema::SchemaObject
          def dependencies(include_parent = false)
            include_parent ? [ parent ] : []
          end
          
          ############################################################################
          ### Check interface
          ############################################################################
          
          # @see DbAgile::Core::Schema::SchemaObject
          def _semantics_check(clazz, buffer)
          end
      
          ############################################################################
          ### About IO
          ############################################################################
        
          # Delegation pattern on YAML flushing
          def to_yaml(opts = {})
            definition.to_yaml(opts)
          end
          
          # Returns a string representation
          def to_s
            "Relview #{name} #{definition.inspect}"
          end
          
        end # class Relview
      end # module Logical
    end # module Schema
  end # module Core
end # module DbAgile
