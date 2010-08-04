module DbAgile
  module Algebra
    module Physical
      class TransformCursor < Physical::Cursor
        
        # Builds a cursor instance with info about ordering
        def initialize(delegate, tblock, &block)
          @delegate = delegate
          @tblock = tblock || block
          super(delegate.order)
        end
        
        #######################################################################
        
        # Transforms a given tuple
        def _transform(tuple)
          @tblock.call(tuple)
        end
        
        #######################################################################
        
        def reset
          @delegate.reset
          current
        end
        
        def next
          _transform(@delegate.next)
        end
        
        def current
          _transform(@delegate.current)
        end
        
        def has_next?
          @delegate.has_next?
        end
        
        def mark
          @delegate.mark
        end
        
        def rewind(mark)
          @delegate.rewind(mark)
          current
        end
        
        def dup
          TransformCursor.new(@delegate.dup, @tblock)
        end
        
      end # class TransformCursor
    end # module Physical
  end # module Algebra
end # module DbAgile