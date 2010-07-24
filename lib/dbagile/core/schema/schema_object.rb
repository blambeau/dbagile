module DbAgile
  module Core
    class SchemaObject
      
      # Parent object
      attr_accessor :parent
        
      # Returns true if this schema object is composite, false
      # otherwise
      def composite?
        self.kind_of?(SchemaObject::Composite)
      end
      
      # Convenient method for !composite?
      def part?
        !composite?
      end
      
      # Returns the builder handler for this object
      def builder_handler
        DbAgile::RubyTools::class_unqualified_name(self.class).downcase.to_sym
      end

      private :parent=
    end # class SchemaObject
  end # module Core
end # module DbAgile
require 'dbagile/core/schema/part'
require 'dbagile/core/schema/composite'
require 'dbagile/core/schema/logical'
require 'dbagile/core/schema/physical'
