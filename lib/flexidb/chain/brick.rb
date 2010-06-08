module FlexiDB
  module Chain
    # 
    # Defines common contract of all Bricks inside the update chain
    #
    class Brick
      
      # Brick options
      attr_reader :options
      
      # Next brick in the chain
      attr_reader :delegate
      
      # Creates a brick instance with a given delegate
      def initialize(delegate, options = {})
        @options = default_options.merge(options)
        @delegate = delegate
      end
      
      # Returns default brick options
      def default_options
        {}
      end
      
      # Returns the SQL adapter which is at end of the chain
      def adapter
        @adapter ||= delegate.adapter
      end
      
      # Computes and returns the heading of a tuple
      def tuple_heading(tuple)
        heading = {}
        tuple.each_pair{|name, value| heading[name] = value.class unless value.nil?}
        heading
      end
      
      # Makes an insertion inside a table
      def insert(table, tuple)
        delegate.insert(table, tuple)
      end
      
    end # class Brick
  end # module Chain
end # module FlexiDB