module DbAgile
  module Core
    module Schema
      module Migrate
        class CreateTable < Migrate::Operation

          def to_sql92
            "CREATE TABLE (#{ops_to_sql92(operations)})"
          end
          
        end # class CreateTable
      end # module Migrate
    end # module Schema
  end # module Core
end # module DbAgile
