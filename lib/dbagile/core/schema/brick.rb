module DbAgile
  module Core
    class Schema
      #
      # Parent class of all schema objects
      #
      class Brick
        
        ############################################################################
        ### Schema computation helper
        ############################################################################
        
        # Delegate pattern on empty?
        def empty?
          if brick_composite?
            brick_children.all?{|b| b.brick_composite? && b.empty?}
          else
            Kernel.raise DbAgile::Error, "empty? called on non composite brick"
          end
        end
        
        ############################################################################
        ### Brick pseudo-private contract
        ############################################################################

        # Returns the parent brick
        attr_accessor :parent
        
        # Returns the brick builder handler
        def brick_builder_handler
          Kernel.raise NotImplementedError
        end

        # Is this object a composite one?
        def brick_composite?
          Kernel.raise NotImplementedError
        end
        
        # Returns true if this brick is considered empty.
        # Non-composite bricks should always return false.
        def brick_empty?
          if brick_composite?
            Kernel.raise NotImplementedError
          else
            false
          end
        end
        
        # Returns an array with child bricks. 
        # Non composite bricks should return an empty array 
        def brick_children
          if brick_composite?
            Kernel.raise NotImplementedError
          else
            []
          end
        end
        
        # Returns a sub brick by name
        def [](name)
          if brick_composite?
            Kernel.raise NotImplementedError
          else
            Kernel.raise DbAgile::Error, "[] called on non composite brick"
          end
        end
        
        # Sets a sub brick by name.
        # Non-composite should not define this method 
        def []=(name, definition)
          if brick_composite?
            Kernel.raise NotImplementedError
          else
            Kernel.raise DbAgile::Error, "[]= called on non composite brick"
          end
        end
        
        private :parent=
      end # class Brick
    end # class Schema
  end # module Core
end # module DbAgile