module DbAgile
  module Commands
    #
    # Defines the contract to be an environment for dbagile commands.
    #
    # This class already implements a basic contract on top of readline,
    # therefore expecting an interactive console environment. It may be 
    # reimplemented from scratch for other situations. In such a case only 
    # public methods need to be implemented.
    #
    class Environment
      
      # The output buffer to use for user requests
      attr_reader :input_buffer
      
      # The output buffer to use for display
      attr_reader :output_buffer
      
      # Creates an Environment instance with two buffers
      def initialize(input_buffer = STDIN, output_buffer = STDOUT)
        @input_buffer, @output_buffer = input_buffer, output_buffer
      end
      
      #
      # Asks something to the user/oracle. If a continuation block is given
      # yields it with result returns block result. Simply returns the value 
      # otherwise.
      #
      # This method is provided when something needs to be asked to the user. The 
      # result should be passed as a string to the continuation proc.
      #
      # @param [String] prompt a prompt for user-oriented environments
      # @param [Proc] continuation a optional continuation procedure
      # @return [...] result of the continuation block
      #
      def ask(prompt, &continuation)
        if continuation
          continuation.call(readline(prompt))
        else
          readline(prompt)
        end
      end
      
      # 
      # Prints an information message. An optional color may be provided if the 
      # environment supports colors.
      #
      # @param [String] something a message to print
      # @param [Symbol] an optional color
      # @return [void]
      #
      def say(something, color = nil)
        writeline(something, color)
        nil
      end
      
      # 
      # Displays something.
      #
      # @param [Object] something to write on environment output
      # @return [void]
      #
      def display(something)
        if something.kind_of?(String)
          writeline(something)
        elsif something.kind_of?(Enumerable)
          something.each{|v| display(v)}
        else
          writeline(something.inspect)
        end
        nil
      end
      
      #
      # Handles an error that occured during command execution.
      #
      # @param [Exception] error the error that was raised
      # @return nil to continue execution, an error to raise otherwise
      #
      def on_error(command, error)
        case error
          when OptionParser::ParseError, DbAgile::Error, Sequel::Error
            say(error.message, :red)
            display(command.options.to_s)
          else
            say("ERROR: #{error.message}", :red)
            display(error.backtrace.join("\n"))
        end
        error
      end


      # Protected section starts here ###################################################
      protected

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
        require 'readline'
        Readline.readline(prompt)
      end
      
      # 
      # Writes a line on the abstract output buffer.
      #
      # This method is an internal tool and is not part of the Environment
      # contract per se. The default implementation writes the line on real
      # output buffer provided at construction.
      #
      # @param [String] something a message to display
      #
      def writeline(something, color = nil)
        something += "\n" unless something =~ /[\n]$/ 
        output_buffer << something
      end

    end # class Environment
  end # module Commands
end # module DbAgile