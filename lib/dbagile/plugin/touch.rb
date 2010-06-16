module DbAgile
  class Plugin
    #
    # Touches records at insert/update time and force default values.
    #
    class Touch < Plugin
      
      # Returns a proc that computes the current time
      def self.now
        lambda{ Time.now }
      end
      
      # Creates a plugin instance
      def initialize(delegate, values, options = {})
        super(delegate, options)
        @values = values
      end
      
      # Default options
      def default_options
        {:at => :both, :force => false}
      end
      
      # Compute the default values
      def __do_touch(tuple, defs = @values)
        values = {}
        defs.each_pair{|key, value|
          next if tuple.key?(key) and not(force?)
          case value
            when NilClass
            when Proc
              value = value.arity > 0 ? value.call(tuple) : value.call
              values[key] = value unless value.nil?
            else
              values[key] = value
          end
        }
        tuple.merge(values)
      end
      
      # Is the force option set?
      def force?
        options[:force]
      end
    
      # Touch records at insert time?  
      def at_insert?
        @at ||= options[:at]
        (@at == :insert) || (@at == :both)
      end
    
      # Touch records at update time?  
      def at_update?
        @at ||= options[:at]
        (@at == :update) || (@at == :both)
      end
      
      # Inject default values to the tuple and delegate
      def insert(transaction, table, tuple)
        tuple = __do_touch(tuple) if at_insert?
        delegate.insert(transaction, table, tuple)
      end
      
      # Inject default values to the tuple and delegate
      def update(transaction, table, proj, tuple)
        tuple = __do_touch(tuple) if at_update?
        delegate.update(transaction, table, proj, tuple)
      end
      
      private :__do_touch
    end # class Touch
  end # class Plugin
end # module DbAgile
    
      
