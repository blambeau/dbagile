require 'dbagile/core/schema/computations/stage/expand_helper'
require 'dbagile/core/schema/computations/stage/collapse_helper'
require 'dbagile/core/schema/computations/stage/stager'
module DbAgile
  module Core
    module Schema
      module Computations
        module Stage
          
          # Default options to use for staging
          DEFAULT_STAGE_OPTIONS = Stage::Stager::DEFAULT_OPTIONS
          
          # Stages a schema and returns an ordered list of abstraction 
          # operations to perform on the database
          def stage_operations(schema, options)
            Stage::Stager.new.run(schema, DEFAULT_STAGE_OPTIONS.merge(options))
          end
          
        end # module Stage

        # Default options to use for staging
        DEFAULT_STAGE_OPTIONS = Stage::Stager::DEFAULT_OPTIONS
          
        extend(Stage)
      end # module Computations
    end # module Schema
  end # module Core
end # module DbAgile
