module DbAgile
  module Core
    module Schema
      module Migrate
        class DropTable < Migrate::Operation
        
          # The table name
          attr_reader :table_name
        
          # Creates an alter table operation instance
          def initialize(table_name)
            unless table_name.kind_of?(Symbol)
              raise ArgumentError, "Symbol expected for table name, got #{table_name.inspect}"
            end
            @table_name = table_name
          end
          
        end # class DropTable
      end # module Migrate
    end # module Schema
  end # module Core
end # module DbAgile
