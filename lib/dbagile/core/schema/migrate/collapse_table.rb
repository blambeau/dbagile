module DbAgile
  module Core
    module Schema
      module Migrate
        class CollapseTable < Migrate::Operation

          def to_sql92
            "ALTER TABLE DROP #{ops_to_sql92(operations)}"
          end
          
        end # class CollapseTable
      end # module Migrate
    end # module Schema
  end # module Core
end # module DbAgile
