module DbAgile
  module Core
    module Schema
      class SchemaObject
      
        # Parent object
        attr_accessor :parent
        
        # Object status
        attr_accessor :status
        
        ############################################################################
        ### Schema typing
        ############################################################################
        
        # Returns true if this schema object is composite, false
        # otherwise
        def composite?
          self.kind_of?(Schema::Composite)
        end
      
        # Convenient method for !composite?
        def part?
          !composite?
        end
      
        ############################################################################
        ### Schema hierarchy
        ############################################################################
        
        # Returns object's ancestors
        def ancestors
          parent.nil? ? [] : [ parent ] + parent.ancestors
        end
        
        # Returns outside dependencies only
        def outside_dependencies
          deps = dependencies
          deps.delete_if{|d| d.ancestors.include?(self)}
        end
        
        # Returns the main schema instance
        def schema
          @schema ||= (parent && parent.schema)
        end
        
        # Returns relation variable of this object, if any
        def relation_variable
          if self.kind_of?(DbAgile::Core::Schema::Logical::Relvar)
            self
          elsif parent
            parent.relation_variable
          else
            raise NoMethodError, "undefined method relation_variable for #{self.class}"
          end
        end
        
        ############################################################################
        ### Package internal methods
        ############################################################################
        
        # Returns the builder handler for this object
        def builder_handler
          unqualified = DbAgile::RubyTools::class_unqualified_name(self.class).to_s
          unqualified.gsub(/[A-Z]/){|x| "_#{x.downcase}"}[1..-1]
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