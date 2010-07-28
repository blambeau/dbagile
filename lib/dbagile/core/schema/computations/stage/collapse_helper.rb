module DbAgile
  module Core
    module Schema
      module Computations
        module Stage
          class CollapseHelper
            
            # Stager under execution
            attr_reader :stager
            
            # Relation variable helped
            attr_reader :relation_variable
            
            # List of sub operations, in order
            attr_reader :operations
            
            # Creates an collapse helper
            def initialize(stager, relation_variable)
              @stager, @relation_variable = stager, relation_variable
              @operations = []
            end
            
            # Create/alter an attribute
            def attribute(attribute)
              operations << [:attribute, attribute]
            end
    
            # Create/alter a candidate key
            def candidate_key(ckey)
              operations << [:candidate_key, ckey]
            end
    
            # Create/alter a foreign key
            def foreign_key(fkey)
              operations << [:foreign_key, fkey]
            end
    
            # Create/alter an index
            def index(index)
              operations << [:index, index]
            end
            
            # Flush operations
            def flush
              operations.collect{|op| 
                [:ALTER_TABLE, relation_variable.name, :"drop_#{op[0]}", op[1]]
              }
            end

          end # class CollapseHelper
        end # module Stage
      end # module Computations
    end # module Schema
  end # module Core
end # module DbAgile
