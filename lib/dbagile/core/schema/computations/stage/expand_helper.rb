module DbAgile
  module Core
    module Schema
      module Computations
        module Stage
          class ExpandHelper
            
            # Stager under execution
            attr_reader :stager
            
            # Relation variable helped
            attr_reader :relation_variable
            
            # Kind of operation (CREATE/ALTER)
            attr_reader :master_op_kind
            
            # List of sub operations, in order
            attr_reader :operations
            
            # Creates an expand helper
            def initialize(stager, relation_variable)
              @stager, @relation_variable = stager, relation_variable
              if stager.relvar_exists?(relation_variable)
                @master_op_kind = :ALTER_TABLE
              else
                @master_op_kind = :CREATE_TABLE
              end
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
              if master_op_kind == :CREATE_TABLE
                [ [:CREATE_TABLE, relation_variable.name, operations] ]
              else
                operations.collect{|op| 
                  [:ALTER_TABLE, relation_variable.name, :"add_#{op[0]}", op[1]]
                }
              end
            end

          end # class ExpandHelper
        end # module Stage
      end # module Computations
    end # module Schema
  end # module Core
end # module DbAgile
