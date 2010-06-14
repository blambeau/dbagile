module DbAgile
  class Engine
    #
    # Specification of Environment for the main dbagile command line tool.
    #
    # This implementation relies on Readline and Highline (optional), maintains 
    # the command history and so on.
    #
    class ConsoleEnvironment < Environment
      
      # Highline instance
      attr_reader :highline
      
      # Creates an environment instance
      def initialize
        require 'readline'
        load_history
        begin 
          require 'highline'
          @highline = HighLine.new
        rescue LoadError
          puts "DbAgile console is much more friendly with highline\ntry 'gem install highline'"
        end
      end
      
      # Loads dbagile engine's history
      def load_history
        histfile = File.join(ENV['HOME'], '.dbagile_history')
        if File.exists?(histfile)
          File.readlines(histfile).each{|c| 
            Readline::HISTORY.push(c) unless c.strip.empty?
          }
        end
      end
      
      # Saves dbagile engine's history
      def save_history
        histfile = File.join(ENV['HOME'], '.dbagile_history')
        File.open(histfile, 'w') do |io|
          hist = Readline::HISTORY.to_a
          hist = hist.reverse[0..(ENV['HISTORY'].to_i || 100)]
          hist.reverse.each{|c| 
            (io << c << "\n") unless c.strip.empty?
          }
        end
      end
      
      # Reads a line on the abstract input buffer and returns it.
      # Stolen on http://bogojoker.com/readline/
      def readline(prompt)
        line = Readline.readline(prompt, true)
        if line =~ /^\s*$/ or Readline::HISTORY.to_a[-2] == line
          Readline::HISTORY.pop
        end
        line
      end
      
      # Writes a line on the abstract output buffer.
      def writeline(something, color = nil)
        if highline
          something = something.to_s
          something = highline.color(something, color) if color
          highline.say(something)
        else
          STDOUT << something.to_s
        end
      end
      
    end # class HighlineEnvironment
  end # class Engine
end # module DbAgile