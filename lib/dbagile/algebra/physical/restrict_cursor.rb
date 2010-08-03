module DbAgile
  module Algebra
    module Physical
      class RestrictCursor < Physical::Cursor
        
        # Creates a restriction cursor instance
        def initialize(delegate, predicate = nil, &block)
          @delegate = delegate
          @predicate = predicate || block
          super(@delegate.order)
          @next = nil
          find_next
        end
        
        #######################################################################
        
        def find_next
          begin 
            @next = @delegate.next
          end until @next.nil? or @predicate.call(@next)
        end
        
        def reset
          @delegate.reset
          find_next
          @next
        end
        
        def next
          to_return = @next
          find_next
          to_return
        end
        
        def current
          @next
        end
        
        def has_next?
          !@next.nil?
        end
        
        def mark
          [@next, @delegate.mark]
        end
        
        def rewind(mark)
          @next, mark = mark
          @delegate.rewind(mark)
          @next
        end
        
        #######################################################################
        
        def dup
          RestrictCursor.new(@delegate.dup, @predicate)
        end
        
      end # class ArrayCursor
    end # module Physical
  end # module Algebra
end # module DbAgile