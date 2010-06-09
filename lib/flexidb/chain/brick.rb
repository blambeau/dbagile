module FlexiDB
  module Chain
    # 
    # Defines common contract of all Bricks inside the update chain
    #
    class Brick
      include Utils
      include Adapter::Delegate
      
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
        @adapter ||= (delegate.respond_to?(:adapter) ? delegate.adapter : delegate)
      end
    
    end # class Brick
  end # module Chain
end # module FlexiDB