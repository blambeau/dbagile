module DbAgile
  class Environment
    module OnError
      
      # Show backtrace on errors?
      attr_writer :show_backtrace
      
      # Shows the backtrace when an error occurs?
      def show_backtrace?
        @show_backtrace
      end
      
      #
      # Handles an error that occured during command execution.
      #
      # @param [Exception] error the error that was raised
      # @return nil to continue execution, an error to raise otherwise
      #
      def on_error(command, error)
        case error
          when SystemExit
          when OptionParser::ParseError
            say(error.message, :red)
            display(command.options.to_s)
          when Sequel::Error, IOError
            say(error.message, :red)
          when DbAgile::SchemaSemanticsError
            say(error.message(true), :red)
          when DbAgile::InternalError
            say("DbAgile encountered an internal error.\n Please replay with dba --backtrace and report the error!", :red)
            say(error.message, :red)
          when DbAgile::Error
            say(error.message, :red)
          when Interrupt
            say("Command interrupted by user", :magenta)
          else
            say("ERROR (#{error.class}): #{error.message}", :red)
        end
        if show_backtrace?
          say(error.backtrace.join("\n"))
        end
        error
      end

    end # module OnError
  end # class Environment
end # module DbAgile
