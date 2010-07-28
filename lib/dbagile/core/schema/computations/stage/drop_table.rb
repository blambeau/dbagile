module DbAgile
  module Core
    module Schema
      module Computations
        module Stage
          class DropTable < Operation
          
            # The relation variable representing the table
            attr_reader :relation_variable
          
            # Creates an alter table operation instance
            def initialize(relation_variable)
              @relation_variable = relation_variable
            end
            
          end # class DropTable
        end # module Stage
      end # module Computations
    end # module Schema
  end # module Core
end # module DbAgile
