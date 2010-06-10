module DbAgile
  class Engine
    module TestEnvironment
      
      attr_accessor :input_lines
      attr_accessor :output_lines
      
      # 
      # Reads a line on the abstract input buffer and returns it.
      #
      # This method is an internal tool and is not part of the Environment
      # contract per se. The default implementation relies on Readline.
      #
      # @param [String] a prompt to display
      # @return [String] line that has been read
      #
      def readline(prompt)
        input_lines.shift
      end
      
      # 
      # Writes a line on the abstract output buffer.
      #
      # This method is an internal tool and is not part of the Environment
      # contract per se. The default implementation relies on Readline.
      #
      # @param [String] something a message to display
      #
      def writeline(something, color = nil)
        output_lines << something
      end
      
    end # module TestEnvironment
  end # class Engine
end # module DbAgile