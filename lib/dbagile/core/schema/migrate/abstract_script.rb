module DbAgile
  module Core
    module Schema
      module Migrate
        class AbstractScript
          include Enumerable
        
          # Operations in this abstract script
          attr_reader :operations
        
          # Creates an abstract script instance
          def initialize
            @operations = []
          end
        
          # Yields the block with each operation in turn
          def each(&block)
            operations.each(&block)
          end
        
          # Pushes operations in this abstract script
          def <<(*ops)
            self.operations.push(*ops)
          end
        
        end # class AbstractScript
      end # module Migrate
    end # module Schema
  end # module Core
end # module DbAgile
require 'dbagile/core/schema/migrate/operation'
require 'dbagile/core/schema/migrate/create_table'
require 'dbagile/core/schema/migrate/drop_table'
require 'dbagile/core/schema/migrate/expand_table'
require 'dbagile/core/schema/migrate/collapse_table'
