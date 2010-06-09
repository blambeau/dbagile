module FlexiDB
  class Engine
    class HighlineEnvironment
      
      # Highline instance
      attr_reader :highline
      
      # Creates a highline environment
      def initialize
        require 'highline'
        @highline = HighLine.new
      end
      
      # Asks something
      def ask(what)
        highline.ask(what)
      end
      
      # Says something
      def say(what)
        highline.say(what.to_s)
      end
      
      # Prints an error
      def error(message)
        highline.say(highline.color("ERROR: #{message}", :red))
      end
      
    end # class HighlineEnvironment
  end # class Engine
end # module FlexiDB