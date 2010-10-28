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
        alias :terminal? :part?
        
        ############################################################################
        ### Schema typing
        ############################################################################
        
        # Returns true if this object is a logical object, false otherwise
        def logical?
          relvar? or attribute? or constraint?
        end
        
          # Returns true if this object is a relation view, false otherwise
          def relview?
            self.kind_of?(Schema::Logical::Relview)
          end
        
          # Returns true if this object is a relation variable, false otherwise
          def relvar?
            self.kind_of?(Schema::Logical::Relvar)
          end
        
          # Returns true if this object is an attribute, false otherwise
          def attribute?
            self.kind_of?(Schema::Logical::Attribute)
          end
        
          # Returns true if this object is a constraint, false otherwise
          def constraint?
            self.kind_of?(Schema::Logical::Constraint)
          end
      
            # Returns true if this object is a candidate key, false otherwise
            def candidate_key?
              self.kind_of?(Schema::Logical::Constraint::CandidateKey)
            end
      
            # Returns true if this object is a primary key, false otherwise
            def primary_key?
              self.candidate_key? and self.primary?
            end
      
            # Returns true if this object is a foreign key, false otherwise
            def foreign_key?
              self.kind_of?(Schema::Logical::Constraint::ForeignKey)
            end
      
        # Returns true if this object is a physical object, false otherwise
        def physical?
          index?
        end
        
          # Returns true if this object is an index, false otherwise
          def index?
            self.kind_of?(Schema::Physical::Index)
          end
        
        ############################################################################
        ### Schema hierarchy
        ############################################################################
        
        # Returns the main schema instance
        def schema
          @schema ||= (parent && parent.schema)
        end
        
        # Returns object's ancestors
        def ancestors
          parent.nil? ? [] : [ parent ] + parent.ancestors
        end
        
        # Returns outside dependencies only
        def outside_dependencies
          deps = dependencies
          deps.delete_if{|d| d.ancestors.include?(self)}
        end
        
        # Returns objects depending on this
        def outside_dependents
          selected = []
          schema.visit{|part, parent|
            if part.part? and not(part.ancestors.include?(self))
              deps = part.outside_dependencies
              deps = deps.collect{|d| d.ancestors}.flatten.uniq
              selected << part if deps.include?(self)
            end
          }
          selected
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
