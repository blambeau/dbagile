module DbAgile
  module Core
    module Schema
      module Computations
        module Stage
          class CreateTable < Operation
          
            # The relation variable representing the table
            attr_reader :relation_variable
          
            # The sub operations
            attr_reader :operations
          
            # Creates an alter table operation instance
            def initialize(relation_variable)
              @relation_variable = relation_variable
              @operations = []
            end
          
          end # class CreateTable
        end # module Stage
      end # module Computations
    end # module Schema
  end # module Core
end # module DbAgile
