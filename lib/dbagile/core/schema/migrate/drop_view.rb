module DbAgile
  module Core
    module Schema
      module Migrate
        class DropView < Migrate::Operation

          def to_sql92
            "DROP VIEW #{table_name}"
          end
          
        end # class DropView
      end # module Migrate
    end # module Schema
  end # module Core
end # module DbAgile
