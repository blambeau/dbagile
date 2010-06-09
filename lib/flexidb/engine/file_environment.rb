module FlexiDB
  class Engine
    class FileEnvironment

      # Creates an environment instance
      def initialize(path)
        @path = path
        @lines = File.readlines(path)
      end

      # Asks something
      def ask(what)
        until @lines.empty?
          line = @lines.shift.strip
          if line[0,1] == "#" or line.empty?
            say(line)
          elsif line =~ /^([^\s]+)\s*(.*)$/
            cmd, args = $1, Kernel.eval("[#{$2}]")
            return [cmd, args]
          else
            raise "Unknown command: #{line}"
          end
        end
        [:quit, []]
      end
      
      # Says something
      def say(what)
        puts(what.to_s)
      end
      
      # Prints an error
      def error(message)
        message = "ERROR: #{message}"
        puts(message)
      end
      
    end # class FileEnvironment
  end # class Engine
end # module FlexiDB
      
