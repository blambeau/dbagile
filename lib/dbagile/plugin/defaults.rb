module DbAgile
  class Plugin
    #
    # Makes a table flexible in the sense that new columns are automatically
    # added when not existing at insert time.
    #
    class Defaults < Plugin
      
      # Creates a plugin instance
      def initialize(delegate, defaults, options = {})
        super(delegate, options)
        @defaults = defaults
      end
      
      # Compute the default values
      def compute_defaults(tuple, defs = @defaults)
        defaults = {}
        defs.each_pair{|key, value|
          case value
            when NilClass
            when Proc
              value = value.arity > 0 ? value.call(tuple) : value.call
              defaults[key] = value unless value.nil?
            else
              defaults[key] = value
          end
        }
        defaults
      end
      
      # Inject default values to the tuple and delegate
      def insert(table, tuple)
        tuple = tuple.merge(compute_defaults(tuple))
        delegate.insert(table, tuple)
      end
      
      private :compute_defaults
    end # class Defaults
  end # class Plugin
end # module DbAgile
    
      
