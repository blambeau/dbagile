module DbAgile
  class Engine
    #
    # Defines the contract to be an engine environment.
    #
    # This class already implements a basic contract on top of readline. 
    # It may be reimplemented from scratch for other situations. In such a 
    # case only public methods (next_command, ask and say) need to be 
    # implemented.
    #
    class Environment
      
      # The engine which is currently running
      attr_accessor :engine
      
      #
      # Ask the environment to find the next command to execute and to pass 
      # it to the continuation block.
      #
      # A command is a pair (command_name: Symbol, args: Array). This pair has
      # to be passed as an array to the continuation object.
      #
      # @param [String] prompt a prompt for user-oriented environments
      # @param [Proc] continuation a continuation procedure
      # @return [...] result of the continuation block
      #
      def next_command(prompt, &continuation)
        while true
          line = readline(prompt).strip
          unless line[0,1] == "#" or line.empty?
            cmd = parse_command(line)
            return continuation.call(cmd)
          end
        end
      end
      
      #
      # Asks something to the user/oracle and pass the result to the continuation
      # proc.
      #
      # This method is provided when something needs to be asked to the user. The 
      # result should be passed as a string to the continuation proc.
      #
      # @param [String] prompt a prompt for user-oriented environments
      # @param [Proc] continuation a continuation procedure
      # @return [...] result of the continuation block
      #
      def ask(prompt, &continuation)
        continuation.call(readline(prompt))
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
      # Handles an error that occured during last command execution.
      #
      # @param [Exception] error the error that was raised
      # @return nil to continue execution, an error to raise otherwise
      #
      def on_error(error)
        say("ERROR: #{error.message}", :red)
      end


      # Protected section starts here ###################################################
      protected

      # 
      # Parses a command (line) and returns a [:command_name, args] pair.
      #
      # @param [String] line a command previously read with readline
      # @return [Array] the parsed command pair [:command_name, args]
      #
      def parse_command(line)
        if line =~ /^([^\s]+)\s*(.*)$/
          begin
            cmd, args = $1, Kernel.eval("[#{$2}]").compact
            [cmd, args]
          rescue Exception => ex
            engine.invalid_command!(line)
          end
        else
          engine.invalid_command!(line)
        end
      end

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
      # contract per se. The default implementation relies on Readline.
      #
      # @param [String] something a message to display
      #
      def writeline(something, color = nil)
        STDOUT << something << "\n"
      end

    end # class Environment
  end # class Engine
end # module DbAgile