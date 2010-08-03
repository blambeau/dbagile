module DbAgile
  module Algebra
    module Physical
      class ArrayCursor < Physical::Cursor
        
        # Creates a cursor instance
        def initialize(array, order)
          super(order)
          @array = array
          @position = 0
        end
        
        #
        # Resets the iterator, and position it on the first tuple
        #
        def reset
          @position = 0
          current
        end
        
        #
        # Returns the next tuple and position the iterator on the next 
        # one. Returns nil if there is no tuple remaining
        #
        def next
          res = @array[@position]
          @position += 1
          res
        end
        
        #
        # Returns the tuple at the current position. Does not have any
        # effect on the cursor position
        #
        def current
          @array[@position]
        end
        
        #
        # Returns true if a next tuple has to be returned, 
        # false otherwise
        #
        def has_next?
          @position < @array.size
        end
        
        #
        # Gets a mark on the current tuple
        #
        def mark
          @position
        end
        
        #
        # Rewind on a mark previously obtained with mark
        #
        def rewind(mark)
          @position = mark
          current
        end
        
        # Returns an array with tuples
        def to_a
          @array
        end
        
        # Duplicates this iterator
        def dup
          ArrayCursor.new(@array, @order)
        end
        
      end # class Iterator
    end # module Physical
  end # module Algebra
end # module DbAgile