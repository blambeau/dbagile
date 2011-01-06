module DbAgile
  class Environment
    module Testing 
      
      # Returns the output buffer as a string
      def output_buffer_str
        if self.output_buffer.kind_of?(StringIO)
          output_buffer.string
        else
          raise DbAgile::AssumptionFailedError, "StringIO expected as output buffer"
        end
      end
      
      #
      # Returns true if the current output buffer matches a regular expression
      #
      def has_flushed?(rx)
        (self.output_buffer_str =~ rx) ? true : false
      end
      
    end # module Testing
  end # class Environment
end # module DbAgile