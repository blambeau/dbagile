module DbAgile
  module Algebra
    module Physical
      class Cursor
        include Enumerable
        
        # Info about ordering
        attr_reader :order
        
        # Builds a cursor instance with info about ordering
        def initialize(order)
          @order = order
        end
        
        #######################################################################
        
        #
        # Resets the iterator, and position it on the first tuple
        #
        def reset
        end
        
        #
        # Returns the next tuple and position the iterator on the next 
        # one. Returns nil if there is no tuple remaining
        #
        def next
        end
        
        #
        # Returns the tuple at the current position. Does not have any
        # effect on the cursor position
        #
        def current
        end
        
        #
        # Returns true if a next tuple has to be returned, 
        # false otherwise
        #
        def has_next?
        end
        
        #
        # Gets a mark on the current tuple
        #
        def mark
        end
        
        #
        # Rewind on a mark previously obtained with mark
        #
        def rewind(mark)
        end
        
        #
        # Duplicates this cursor
        #
        def dup
        end
        
        #######################################################################
        
        # Yields the block with each tuple in turn
        def each
          d = self.dup
          while d.has_next?
            yield(d.next)
          end
        end
        
        # Returns an array with tuples
        def to_a
          self.collect{|t| t}
        end
        
      end # class Cursor
    end # module Physical
  end # module Algebra
end # module DbAgile