module DbAgile
  class Engine
    # 
    # Specialization of Environment to take commands inside a text file.
    #
    # This environment automatically sends a :quit command at the end of
    # the file parsing.
    #
    class FileEnvironment < Environment

      # Creates an environment instance
      def initialize(path)
        @path = path
      end

      # Returns pending lines
      def lines
        @lines ||= File.readlines(@path)
      end

      # Reads a line on the abstract input buffer and returns it.
      # Stolen on http://bogojoker.com/readline/
      def readline(prompt)
        if (lns = lines).empty?
          "quit"
        else
          lns.shift
        end
      end

    end # class FileEnvironment
  end # class Engine
end # module DbAgile
      
