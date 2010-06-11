module DbAgile
  class SequelAdapter
    class SequelLogger
      
      # Creates a logger instance
      def initialize(delegate)
        @delegate = delegate
        @silent = false
      end
      
      # Do tracing?
      def trace?
        !@silent and @delegate
      end
      
      # Makes the logger silent during block execution
      def silent!
        @silent = true
        yield
        @silent = false
      end
      
      # Logs a sql trace
      def do_trace(sql, method = :info)
        case @delegate
          when Logger
            @delegate.send(method, sql)
          else
            @delegate << sql << "\n"
        end
      end
    
      # Logs with debug 
      def debug(msg)
        do_trace(msg, :debug) if trace? 
      end
      
      # Logs with info  
      def info(msg)
        do_trace(msg, :info) if trace? 
      end
      
      # Logs with warn  
      def warn(msg)
        do_trace(msg, :warn) if trace? 
      end
      
      # Logs with error  
      def error(msg)
        do_trace(msg, :error) if trace? 
      end
      
      # Logs with fatal 
      def fatal(msg)
        do_trace(msg, :fatal) if trace? 
      end
      
    end # class SequelLogger
  end # class SequelAdapter
end # module DbAgile