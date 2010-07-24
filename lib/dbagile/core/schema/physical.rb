module DbAgile
  module Core
    module Schema
      class Physical < Schema::Composite
        
        # @see DbAgile::Core::Schema::Composite#_default_parts
        def _default_parts
          {:indexes => Physical::Indexes.new}
        end
                
        # @see DbAgile::Core::Schema::Composite#_install_eigenclass_methods?
        def _install_eigenclass_methods?
          true
        end
        
      end # class Logical
    end # module Schema
  end # module Core
end # module DbAgile
require 'dbagile/core/schema/physical/indexes'
require 'dbagile/core/schema/physical/index'
