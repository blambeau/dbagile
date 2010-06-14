module DbAgile
  class Engine
    module Basics
      
      # Asserts that something is true or raises an error
      def assert(something, msg = "Assertion failed")
        raise(msg) unless something
        true
      end
      
      # Prints the backtrace of the last error
      def backtrace
        engine.last_error
      end
      
      # Returns the current database
      def database
        engine.connected!
        engine.database
      end
      
      # Returns true if all args are equal, false otherwise
      def equal?(*args)
        args.uniq.size == 1
      end
      
      # Displays an object
      def display(what)
        case what
          when Exception
            engine.display("#{what.message}\n" << what.backtrace.join("\n"))
          when ::Sequel::Dataset
            ::DbAgile::PrettyTable::print(what, []).each{|line| engine.display(line)}
          when Symbol, String
            display(database.dataset(what))
          else
            engine.display(what.inspect)
        end
      end
      
      # Shows help
      def help
        engine.say("Not implemented yet, under progress...")
      end
      
      # Executes the command on the engine
      def quit
        engine.disconnect
        engine.quit
      end

    end # module Basics
  end # class Engine
end # module DbAgile