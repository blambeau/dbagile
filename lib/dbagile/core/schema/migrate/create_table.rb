module DbAgile
  module Core
    module Schema
      module Migrate
        class CreateTable < Migrate::Operation
        
          # The table name
          attr_reader :table_name
        
          # The sub operations
          attr_reader :operations
        
          # Creates an alter table operation instance
          def initialize(table_name)
            unless table_name.kind_of?(Symbol)
              raise ArgumentError, "Symbol expected for table name, got #{table_name.inspect}"
            end
            @table_name = table_name
            @operations = []
          end
        
        end # class CreateTable
      end # module Migrate
    end # module Schema
  end # module Core
end # module DbAgile
