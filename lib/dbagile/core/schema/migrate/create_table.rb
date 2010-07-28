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
          def initialize(relation_variable)
            @table_name = table_name
            @operations = []
          end
        
        end # class CreateTable
      end # module Migrate
    end # module Schema
  end # module Core
end # module DbAgile
