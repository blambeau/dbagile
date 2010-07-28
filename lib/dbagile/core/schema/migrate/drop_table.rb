module DbAgile
  module Core
    module Schema
      module Migrate
        class DropTable < Migrate::Operation
        
          # The table name
          attr_reader :table_name
        
          # Creates an alter table operation instance
          def initialize(relation_variable)
            @table_name = table_name
          end
          
        end # class DropTable
      end # module Migrate
    end # module Schema
  end # module Core
end # module DbAgile
