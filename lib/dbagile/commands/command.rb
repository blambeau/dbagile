require 'optparse'
require 'fileutils'
module DbAgile
  module Commands
    class Command
      
      # Current configuration as a class-level instance variable
      class << self
        attr_accessor :current_config
      end
      
      # Creates an empty command instance
      def initialize
        @buffer = STDOUT
      end
      
      # Parses commandline options provided as an array of Strings.
      def options
        @options  ||= OptionParser.new do |opt|
          opt.program_name = File.basename $0
          opt.version = DbAgile::VERSION
          opt.release = nil
          opt.summary_indent = ' ' * 4
          opt.banner = self.banner.gsub(/^[ \t]+/, "")
    
          opt.separator nil
          opt.separator "Options:"
    
          add_options(opt)

          opt.separator nil
        end
      end

      # Exits with a message, showing options if required
      def exit(msg = nil, show_options=true)
        info msg if msg
        puts options if show_options
        Kernel.exit(-1)
      end
      
      def info(msg)
        raise ArgumentError unless msg.kind_of?(String)
        @buffer << msg << "\n"
      end
      alias :error :info
      
      # Runs the command
      def run(requester_file, argv)
        @requester_file = requester_file
        rest = options.parse!(argv)
        normalize_pending_arguments(rest)
        check_command
        execute_command
      rescue OptionParser::InvalidOption => ex
        exit(ex.message)
      rescue SystemExit
      rescue Exception => ex
        error <<-EOF
          A severe error occured. Please report this to the developers.
        
          #{ex.class}: #{ex.message}
        EOF
        error ex.backtrace.join("\n")
      end
      
      # Loads the user configuration file
      def load_user_config_file(file = File.join(ENV['HOME'], '.dbagile'))
        if File.exists? and File.readable?(file)
          begin
            Kernel.eval(File.read(file))
          rescue Exception => ex
            raise
          end
          true
        else
          false
        end
      end
      
      # Returns the command banner
      def banner
        raise "Command.banner should be overriden by subclasses"
      end

      # Contribute to options
      def add_options(opt)
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
      
    end # class Command
  end # module Commands
end # module DbAgile
