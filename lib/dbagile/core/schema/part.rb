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
        
        ############################################################################
        ### Schema::SchemaObject
        ############################################################################
        
        # Returns an array with part dependencies
        def dependencies(raise_error_on_unfound = true)
          []
        end
        
        # Checks this composite's semantics and collects errors inside buffer
        def semantical_errors
          []
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
        
        # Returns an hash code
        def hash
          [ name, definition ].hash
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