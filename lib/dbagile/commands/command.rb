require 'optparse'
require 'fileutils'
module DbAgile
  module Commands
    class Command
      include ::DbAgile::Commands::Robust
      
      # Current configuration as a class-level instance variable
      class << self
        
        # Tracks subclasses for printing list of command
        # and delegating execution to them.
        def inherited(subclass) 
          super
          @subclasses ||= [] 
          @subclasses << subclass 
        end 

        # Returns known command sub-classes
        def subclasses 
          @subclasses 
        end 
        
        # Returns the command name of a given class
        def command_name_of(clazz)
          /::([A-Za-z0-9]+)$/ =~ clazz.name
          $1.downcase
        end
      
        # Returns a command for a given name, returns nil if it cannot be found
        def command_for(name)
          subclass = subclasses.find{|subclass| command_name_of(subclass) == name}
          subclass.nil? ? nil : subclass.new
        end

      end # class << self
       
      # Buffer used for all messages
      attr_accessor :buffer 
       
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
          add_options(opt)
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
        unsecure_run(requester_file, argv)
      rescue ::DbAgile::Error => ex
        exit(ex.message, false)
      rescue Sequel::Error => ex
        exit(ex.message, false)
      rescue OptionParser::InvalidOption, OptionParser::InvalidArgument => ex
        exit(ex.message)
      rescue SystemExit
      rescue Exception => ex
        error "A severe error occured. Please report this to the developers.\n\n#{ex.class}: #{ex.message}"
        error ex.backtrace.join("\n")
      end
      
      # Runs the command without catching any error
      def unsecure_run(requester_file, argv)
        @requester_file = requester_file
        rest = options.parse!(argv)
        normalize_pending_arguments(rest)
        check_command
        execute_command
      end
      
      # Loads the user configuration file
      def load_user_config_file(file = user_config_file)
        if File.exists?(file) and File.readable?(file)
          Kernel.eval(File.read(file))
          true
        else
          false
        end
      end
      
      # Returns the command banner
      def banner
        raise "Command.banner should be overriden by subclasses"
      end
      
      # Shows the help
      def show_help
        info banner
        info ""
        info short_help
        info ""
      end

      # Aligns a string by appending whitespaces up to size.
      # This method has not effect if size is nil
      def align(string, size = nil)
        return string if size.nil?
        string.to_s + " "*(size - string.to_s.length)
      end

      # Contribute to options
      def add_options(opt)
      end
      
      # Normalizes the pending arguments
      def normalize_pending_arguments(arguments)
        unless arguments.empty?
          show_help
          exit(nil, false)
        end
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
