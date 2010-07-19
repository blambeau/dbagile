module DbAgile
  class SequelAdapter < Adapter
    module ClassMethods
      
      #
      # Overrided to add a SequelTracer instance if trace is on  
      #
      def new(uri, options = {})
        if options[:trace_sql]
          SequelTracer.new(super(uri), options)
        else
          super(uri, options)
        end
      end  
    
    end # module ClassMethods
  end # class SequelAdapter
end # module DbAgile
