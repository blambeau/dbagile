module DbAgile
  module Core
    module Schema
      class SchemaObject
      
        # Parent object
        attr_accessor :parent
        
        # Object annotations
        attr_accessor :annotation
        
        # Returns true if this schema object is composite, false
        # otherwise
        def composite?
          self.kind_of?(Schema::Composite)
        end
      
        # Convenient method for !composite?
        def part?
          !composite?
        end
      
        # Returns the builder handler for this object
        def builder_handler
          DbAgile::RubyTools::class_unqualified_name(self.class).downcase.to_sym
        end
        
        # Returns the arguments to pass to builder handler
        def builder_args
          []
        end
        
        private :parent=
      end # class SchemaObject
    end # module Schema
  end # module Core
end # module DbAgile
require 'dbagile/core/schema/part'
require 'dbagile/core/schema/composite'
require 'dbagile/core/schema/database_schema'
