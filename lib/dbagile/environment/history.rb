module DbAgile
  class Environment
    # 
    # Environment's histroy contract.
    #
    module History

      #
      # Converts an array of arguments to a command line, taking care of putting
      # quotes when needed.
      #
      def to_command_line(argv)
        argv.collect{|c| c = c.strip; c =~ /\s/ ? c.inspect : c}.join(' ')
      end
      
      #
      # Reverse of to_command_line. Returns an array of arguments.
      #
      def from_command_line(command_line)
        argv = command_line.split(" ")
        normalized, quoted = [], nil
        while arg = argv.shift
          if quoted.nil?
            first = arg[0, 1]
            if (first == "'" or first == '"')
              if (arg[-1, 1] == first)
                # don't start recovery, no space at all
                normalized << arg[1..-2]
              else
                # start recovery
                quoted = arg
              end
            else
              # normal case
              normalized << arg
            end
          else
            # continue recovery
            quoted << " " << arg
            if quoted[0, 1] == quoted[-1, 1]
              normalized << quoted[1..-2] 
              quoted = nil
            end
          end
        end
        normalized
      end

      #      
      # Returns an array with command history (from oldest to newest)
      #
      def history
        Readline::HISTORY.to_a
      end
      
      #
      # Returns path to .dbagile_history file
      #
      # Default implementation returns ~/.dbagile_history
      #
      def history_file_path
        @history_file_path ||= File.join(ENV['HOME'], '.dbagile_history')
      end
      
      #
      # Sets the path to the .dbagile_history file
      #
      def history_file_path=(path)
        @history_file_path = path
      end
      
      #
      # Manages history? 
      #
      # Default implementation returns true if @manage_history is not false
      # and an history file path is set.
      #
      def manage_history?
        # @manage_history is nil by default while history is enabled by 
        # default... reason of this strange specification/implementation :)
        !!((@manage_history != false) and history_file_path)
      end
      
      #
      # Sets/Unsets history management (enabled by default).
      #
      def manage_history=(value)
        @manage_history = value
      end
      
      #
      # Pushes something in the history, provided that history management is enabled.
      # Does nothing otherwise. If _line_ is an Array, it is condidered to be ARGV,
      # and encoded as a command line first.
      #
      def push_in_history(line)
        line = to_command_line(line) if line.kind_of?(Array)
        if manage_history?
          line = line.strip
          unless (line =~ /^\s*$/) or (Readline::HISTORY.to_a[-1] == line)
            Readline::HISTORY.push(line)
          end
        end
      end
      
      #
      # Checks if history has been loaded or not.
      #
      def history_loaded?
        @history_loaded
      end
      
      #
      # Loads dbagile's history.
      #
      # This methods expects history_file_path to be set, a precondition states that
      # history management is enabled. This method is not defensive about it (i.e. no
      # check is done).
      #
      def load_history
        if RUBY_VERSION <= "1.9.0" and Readline::HISTORY.empty?
          # There a but in some ruby versions: the first line is not kept by
          # the HISTORY variable. We push two times if it was empty
          Readline::HISTORY.push('')
        end
        
        # Read history file if it exists
        if File.exists?(history_file_path)
          File.readlines(history_file_path).each{|c| 
            Readline::HISTORY.push(c.strip)
          }
        end

        # Mark it as loaded now
        @history_loaded = true
      end
      
      #
      # Saves dbagile's history.
      #
      # This methods expects history_file_path to be set, a precondition states that
      # history management is enabled. This method is not defensive about it (i.e. no
      # check is done).
      #
      def save_history
        File.open(history_file_path, 'w') do |io|
          history = Readline::HISTORY.to_a
          history = history.reverse[0..(ENV['HISTORY'].to_i || 100)]
          history.reverse.each{|c|
            c = c.strip
            io << c << "\n" unless c.empty?
          }
        end
      end
      
    end # module History
  end # class Environment
end # module DbAgile