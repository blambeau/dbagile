module DbAgile
  class Environment
    module Buffering
      
      # The output buffer to use for user requests
      attr_accessor :input_buffer
    
      # The output buffer to use for display
      attr_accessor :output_buffer
    
      # 
      # Flushes something on the output buffer
      #
      # Does nothing when no output buffer has been set.
      #
      # @param [Object] something to write on environment output
      # @return [void]
      #
      def flush(something, append_new_line = true)
        unless output_buffer.nil?
          if something.kind_of?(String)
            output_buffer << something
            if append_new_line and not(something =~ /\n$/)
              output_buffer << "\n"
            end
          elsif something.kind_of?(Enumerable)
            something.each{|v| flush(v, true)}
          else
            flush(something.to_s)
          end
        end
        nil
      end
    
      # 
      # Delegated to the input buffer. Returns nil if no input buffer
      # has been set
      #
      def gets
        input_buffer.nil? ? nil : input_buffer.gets
      end
    
    end # module Interactions
  end # class Environment
end # module DbAgile