module DbAgile
  module Core
    module Schema
      class Part < SchemaObject
        
        # Object name
        attr_reader :name
        
        # Object definition
        attr_reader :definition
      
        # Creates a part instance
        def initialize(name, definition)
          @name = name
          @definition = definition
        end
        
        # Makes a sanity check on the part
        def _sanity_check(schema)
          raise SchemaInternalError, "No name provided on #{self}" if name.nil?
          raise SchemaInternalError, "No definition provided on #{self}" if definition.nil?
        end
        
        # Checks this composite's semantics and collect errors
        def _semantics_check(clazz, buffer)
        end
        
        ############################################################################
        ### Schema typing
        ############################################################################
        
        # Returns true if this object is a logical object, false otherwise
        def logical?
          relvar? or attribute? or constraint?
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
        ### Schema::SchemaObject
        ############################################################################
        
        # Returns an array with part dependencies
        def dependencies(include_parent = false)
          include_parent ? [ parent ] : []
        end
        
        # @see DbAgile::Core::Schema
        def visit(&block)
          block.call(self, parent)
        end
        
        ############################################################################
        ### Equality and hash code
        ############################################################################
      
        # Compares with another part
        def look_same_as?(other)
          return nil unless other.kind_of?(self.class)
          (name == other.name) and (definition == other.definition)
        end
        
        # Duplicates this part
        def dup
          self.class.new(name, definition.dup)
        end
        
        # Returns a string representation
        def to_s
          "#{DbAgile::RubyTools::unqualified_class_name(self.class)}: #{name} #{definition.inspect}"
        end

      end # class Part
    end # module Schema
  end # module Core
end # module DbAgile