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
        
        ############################################################################
        ### Equality and hash code
        ############################################################################
      
        # Compares with another part
        def ==(other)
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
        
      end # class Part
    end # module Schema
  end # module Core
end # module DbAgile