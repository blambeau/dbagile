module DbAgile
  module Algebra
    module Physical
      class CursorInfo
        
        # Heading for iterated tuples
        attr_reader :heading
        
        # Uniqueness information (set of set of attribute names)
        attr_reader :uniqueness
        
        # Ordering information (set of attribute names)
        attr_reader :ordering
        
        # Creates a cursor info instance
        def initialize(heading, uniqueness, ordering)
          @heading, @uniqueness, @ordering = heading, uniqueness, ordering
        end
        
        # Is uniqueness of tuples ensured?
        def uniqueness_ensured?
          not(uniqueness.nil? or uniqueness.empty?)
        end
        
        # Is it a arbitrary ordering ensured?
        def any_ordering_ensured?
          not(ordering.nil? or ordering.empty?)
        end
        
        # Is a specific ordering ensured on names
        def ordering_ensured?(names)
          ordering == names
        end
        
        # Is the ensured ordering on a uniqueness constraint as well?
        def ordered_on_unique?
          return false unless uniqueness_ensured? and any_ordering_ensured? 
          uniqueness.include?(ordering)
        end
        
      end # class CursorInfo
    end # module Physical
  end # module Algebra
end # module DbAgile