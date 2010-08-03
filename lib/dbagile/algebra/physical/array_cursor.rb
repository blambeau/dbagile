module DbAgile
  module Algebra
    module Physical
      class ArrayCursor < Physical::Cursor
        
        # Creates a cursor instance
        def initialize(array, order)
          @array, @position = array, 0
          super(order)
        end
        
        #######################################################################
        
        def reset
          @position = 0
          current
        end
        
        def next
          res = @array[@position]
          @position += 1
          res
        end
        
        def current
          @array[@position]
        end
        
        def has_next?
          @position < @array.size
        end
        
        def mark
          @position
        end
        
        def rewind(mark)
          @position = mark
          current
        end
        
        #######################################################################
        
        def to_a
          @array
        end
        
        # Duplicates this iterator
        def dup
          ArrayCursor.new(@array, @order)
        end
        
      end # class ArrayCursor
    end # module Physical
  end # module Algebra
end # module DbAgile