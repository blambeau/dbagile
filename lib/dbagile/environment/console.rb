module DbAgile
  class Environment
    # 
    # Environment's console contract.
    #
    module Console
      
      # Forces the console width
      def console_width=(width)
        @console_width = width
      end
      
      # Returns with of the console
      def console_width
        @console_width ||= infer_console_width
      end
      
      # Tries to infer the console width
      def infer_console_width
        begin
          gem 'highline', '>= 1.5.2'
          require 'highline'
          HighLine.new.output_cols-3
        rescue LoadError
          say("Console output is pretty with highline. Try 'gem install highline'")
          80
        end
      end
      
    end # module Console
  end # class Environment
end # module DbAgile
