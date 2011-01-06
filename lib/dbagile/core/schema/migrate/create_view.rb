module DbAgile
  module Core
    module Schema
      module Migrate
        class CreateView < Migrate::Operation

          def to_sql92
            "CREATE VIEW #{table_name} (#{relvar.definition})"
          end
          
        end # class CreateView
      end # module Migrate
    end # module Schema
  end # module Core
end # module DbAgile
