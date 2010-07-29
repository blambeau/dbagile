module DbAgile
  module Core
    module Schema
      module Migrate
        class DropTable < Migrate::Operation

          def to_sql92
            "DROP TABLE #{table_name}"
          end
          
        end # class DropTable
      end # module Migrate
    end # module Schema
  end # module Core
end # module DbAgile
