module DbAgile
  module Core
    module Schema
      module Migrate
        class ExpandTable < Migrate::Operation
          
          def to_sql92
            "ALTER TABLE ADD #{ops_to_sql92(operations)}"
          end
          
        end # class ExpandTable
      end # module Migrate
    end # module Schema
  end # module Core
end # module DbAgile
