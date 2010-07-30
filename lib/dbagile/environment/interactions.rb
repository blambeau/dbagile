module DbAgile
  class Environment
    # 
    # Environment's interactions contract.
    #
    module Interactions
      
      # The buffer to use for displaying messages
      attr_reader :message_buffer
    
      # The buffer to use for asking questions
      attr_reader :asking_buffer
      
      ##############################################################################
      ### Robustness
      ##############################################################################
      
      #
      # Asserts that the interactive mode is enabled. Raises a 
      # InteractiveModeRequiredError otherwise.
      #
      def interactive!(msg = nil)
        unless interactive?
          msg = "The interactive mode is required, but disabled."
          raise InteractiveModeRequiredError, msg
        end
      end
      
      ##############################################################################
      ### Configuration
      ##############################################################################
      
      # 
      # Returns true if the environment is interactive, false
      # otherwise
      #
      def interactive?
        @interactive
      end
      
      #
      # Sets the interactive mode.
      #
      # In all cases, the highline instance for interaction is reset
      # to nil.
      #
      def interactive=(value)
        @interactive = value
        @interaction_highline = nil
      end
      
      #
      # Sets the message/output buffer to use for interactions.
      #
      # In all cases, the highline instance for interaction is reset
      # to nil.
      #
      def message_buffer=(buffer)
        @message_buffer = buffer
        @interaction_highline = nil
      end
      
      #
      # Sets the asking/input buffer to use for interactions.
      #
      # In all cases, the highline instance for interaction is reset
      # to nil.
      #
      def asking_buffer=(buffer)
        @asking_buffer = buffer
        @interaction_highline = nil
      end
    
      ##############################################################################
      ### HighLine delegation
      ##############################################################################
      
      #
      # Returns an instance of HighLine for interactions, creating it 
      # if required. 
      #
      # This method factors an HighLine instance even if interactive
      # is set to false. Checking the interactive? flag should be made
      # upstream.
      #
      def interaction_highline
        if @interaction_highline.nil?
          in_buffer  = asking_buffer  || input_buffer
          out_buffer = message_buffer || output_buffer
          @interaction_highline = HighLine.new(in_buffer, out_buffer)
        end
        @interaction_highline
      end
      
      #
      # Asks something to the user/oracle and returns the result.
      #
      # This method is provided when something needs to be asked to the user.
      # It simply returns non_interactive_value if the interaction flag is set 
      # to false. Otherwise, it delegates the call to the interaction highline 
      # instance.
      #
      # @param [String] question a prompt for the question
      # @param [Proc] continuation a optional continuation procedure
      # @param [...] non_interactive_value value to return in non-interactive
      #              mode
      # @return [...] non_interactive_value in non-interactive mode, the result
      #               of continuation proc otherwise. 
      #
      def ask(question, answer_type = String, non_interactive_value = nil, &continuation)
        if interactive?
          interaction_highline.ask(question, answer_type, &continuation)
        else
          nil
        end
      end
      
      #
      # Same specification as ask, but immediately raises an 
      # InteractiveModeRequiredError if the interactive mode is not set!
      #
      def ask!(question, answer_type = String, &continuation)
        interactive!
        ask(question, answer_type, nil, &continuation)
      end
    
      # 
      # Prints an information message on the appropriate buffer. An optional 
      # color may be provided if the environment supports colors.
      #
      # Does nothing when interactive mode is disabled. Delegates the call
      # to highline otherwise.
      #
      # The something argument is expected to be a String. Use display to
      # show complex objects, Enumerable in particular
      #
      # @param [String] something a message to print
      # @param [Symbol] an optional color
      # @return [void]
      #
      def say(something, color = nil)
        if interactive?
          h = interaction_highline
          color.nil? ? h.say(something) : h.say(h.color(something, color))
        end
      end
    
      # 
      # Displays something on the message buffer.
      #
      # Does nothing when interactive mode is disabled. Delegates the call
      # to highline otherwise.
      #
      # @param [Object] something to write on environment output
      # @return [void]
      #
      def display(something, color = nil)
        if interactive?
          if something.kind_of?(String)
            say(something, color)
          elsif something.kind_of?(Enumerable)
            something.each{|v| display(v, color)}
          else
            display(something.to_s, color)
          end
        end
      end
    
      ##############################################################################
      ### Console
      ##############################################################################
      
      #
      # When interaction mode is set, colorizes a string with highline. 
      # Simply returns str otherwise.
      #
      def color(str, color)
        interactive? ? interaction_highline.color(str, color) : str
      end
      
      #
      # Forces the console width. 
      #
      # When a width is set, it will always be returned by console_width, bypassing
      # any attempt to use highline to infer it.
      #
      def console_width=(width)
        @console_width = width
      end
      
      #
      # Returns width of the console. Width set with console_width= is returned in
      # priority. Otherwise, return highline's output_cols in interactive mode.
      # Returns 80 in all other cases.
      #
      def console_width
        @console_width ||= infer_console_width
      end
      
      # Tries to infer the console width
      def infer_console_width
        interactive? ? interaction_highline.output_cols-3 : 80
      end

      private :infer_console_width
    end # module Interactions
  end # class Environment
end # module DbAgile