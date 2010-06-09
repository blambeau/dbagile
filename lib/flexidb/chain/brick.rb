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
        @options = __default_options.merge(options)
        @delegate = delegate
      end
      
      # Returns default brick options
      def __default_options
        {}
      end
      
      private :__default_options
    end # class Brick
  end # module Chain
end # module FlexiDB