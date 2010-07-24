require 'dbagile/core/schema/physical/indexes'
require 'dbagile/core/schema/physical/index'
module DbAgile
  module Core
    class Schema < SchemaObject::Composite
      class Physical < SchemaObject::Composite
        
        # @see DbAgile::Core::SchemaObject::Composite#_default_parts
        def _default_parts
          {:indexes => Physical::Indexes.new}
        end
                
        # @see DbAgile::Core::SchemaObject::Composite#_install_eigenclass_methods?
        def _install_eigenclass_methods?
          true
        end
        
      end # class Logical
    end # class Schema
  end # module Core
end # module DbAgile