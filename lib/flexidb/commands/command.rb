require 'optparse'
require 'fileutils'
module FlexiDB
  module Commands
    class Command
      
      # The verbose level
      attr_accessor :verbose
      
      # Show stack traces?
      attr_accessor :trace
      
      # Creates an empty command instance
      def initialize
        @verbose = false
        @buffer = STDOUT
      end
      
      # Parses commandline options provided as an array of Strings.
      def options
        @options  ||= OptionParser.new do |opt|
          opt.program_name = File.basename $0
          opt.version = FlexiDB::VERSION
          opt.release = nil
          opt.summary_indent = ' ' * 4
          banner = self.banner
          opt.banner = banner.gsub(/^[ \t]+/, "")
    
          opt.separator nil
          opt.separator "Options:"
    
          add_options(opt)

          opt.on("--trace", "Display stack trace on error?") do |value|
            @trace = true
          end
          
          opt.on("--verbose", "-v", "Display extra progress as we progress") do |value|
            @verbose = true
          end
          
          # No argument, shows at tail.  This will print an options summary.
          # Try it and see!
          opt.on_tail("-h", "--help", "Show this message") do
            exit(nil, true)
          end

          # Another typical switch to print the version.
          opt.on_tail("--version", "Show version") do
            exit(opt.program_name << " " << FlexiDB::VERSION << " (c) 2010, Bernard Lambeau", false)
          end
    
          opt.separator nil
        end
      end

      # Runs the command
      def run(requester_file, argv)
        @requester_file = requester_file
        prepare_command(argv)
        check_command
        execute_command
      rescue OptionParser::InvalidOption => ex
        exit(ex.message)
      rescue SystemExit
      rescue Exception => ex
        error <<-EOF
          A severe error occured. Please report this to the developers.
          Try --trace if the trace does not appear
        
          #{ex.class}: #{ex.message}
        EOF
        error ex.backtrace.join("\n") if trace
      end
      
      def shell_exec(what)
        info "shell: #{what}" if verbose
        info `#{what}`
      end
      
      # Exits with a message, showing options if required
      def exit(msg = nil, show_options=true)
        info msg if msg
        puts options if show_options
        Kernel.exit(-1)
      end
      
      def info(msg)
        raise ArgumentError unless msg.kind_of?(String)
        @buffer << msg.gsub(/^[ \t]+/, '') << "\n"
      end
      alias :error :info
      
      # Contribute to options
      def add_options(opt)
      end
      
      # Prepares the command
      def prepare_command(argv)
        rest = options.parse!(argv)
        normalize_pending_arguments(rest)
        self
      end
      
      # Normalizes the pending arguments
      def normalize_pending_arguments(arguments)
        exit
      end
      
      # Checks the command and exit if any option problem is found
      def check_command
      end
      
      # Executes the command
      def execute_command
      end
      
      # Returns the command banner
      def banner
        raise "Command.banner should be overriden by subclasses"
      end
      
      # Runs the sub-class defined command
      def __run(requester_file, arguments)
        raise "Command._run should be overriden"
      end

    end # class Command
  end # module Commands
end # module FlexiDB
