require 'optparse'
require 'fileutils'
require 'dbagile/command/robust'
module DbAgile
  class Command
    include ::DbAgile::Command::Robust
    
    ##############################################################################
    ### Class level constructions
    ##############################################################################
    
    # Environment class to use by default
    DEFAULT_ENVIRONMENT_CLASS = DbAgile::Environment
    
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
        subclass = subclasses.find{|subclass| command_name_of(subclass).to_s == name.to_s}
        subclass.nil? ? nil : subclass.new
      end

    end # class << self
     
    ##############################################################################
    ### Instance variables and construction
    ##############################################################################
    
    # Command execution environment
    attr_reader :environment
     
    # Creates an empty command instance
    def initialize(env = DEFAULT_ENVIRONMENT_CLASS.new)
      @environment = env
      set_default_options
    end
    
    ##############################################################################
    ### Environment delegation
    ##############################################################################
    
    # Delegated to environment
    def say(*args, &block)
      environment.say(*args, &block)
    end
    
    # Delegated to environment
    def display(*args, &block)
      environment.display(*args, &block)
    end
    
    # Delegated to environment
    def output_buffer(*args, &block)
      environment.output_buffer(*args, &block)
    end
    
    # Delegated to environment
    def input_buffer(*args, &block)
      environment.input_buffer(*args, &block)
    end
    
    # Delegated to environment
    def with_config_file(*args, &block)
      environment.with_config_file(*args, &block)
    end

    ##############################################################################
    ### About options
    ##############################################################################
    
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
    
    # Sets the default options
    def set_default_options
    end
    
    # Contribute to options
    def add_options(opt)
    end
    
    ##############################################################################
    ### Command info/help and so on.
    ##############################################################################
    
    # Returns the command banner
    def banner
      raise "Command.banner should be overriden by subclasses"
    end
    
    # Returns a one line help
    def short_help
      raise "Command.banner should be overriden by subclasses"
    end
    
    # Shows the help
    def show_help
      display banner
      display ""
      display short_help
      display ""
    end

    ##############################################################################
    ### Run logic
    ##############################################################################
    
    # Runs the command
    def run(requester_file, argv)
      unsecure_run(requester_file, argv)
      environment
    rescue Exception => ex
      environment.on_error(self, ex)
      environment
    end
    
    # Runs the command without catching any error
    def unsecure_run(requester_file, argv)
      @requester_file = requester_file
      rest = options.parse!(argv)
      normalize_pending_arguments(rest)
      check_command
      execute_command
    end
    
    # Normalizes the pending arguments
    def normalize_pending_arguments(arguments)
      bad_argument_list!(arguments) unless arguments.empty?
    end
    
    # Checks the command
    def check_command
    end
    
    # Executes the command
    def execute_command
    end
    
    ##############################################################################
    ### Deprecated or should be moved
    ##############################################################################
    
    # Aligns a string by appending whitespaces up to size.
    # This method has not effect if size is nil
    def align(string, size = nil)
      return string if size.nil?
      string.to_s + " "*(size - string.to_s.length)
    end
    
  end # class Command
end # module DbAgile
require 'dbagile/command/dba'
require 'dbagile/command/help'
require 'dbagile/command/list'
require 'dbagile/command/add'
require 'dbagile/command/rm'
require 'dbagile/command/use'
require 'dbagile/command/ping'
require 'dbagile/command/show'
require 'dbagile/command/export'
require 'dbagile/command/import'
require 'dbagile/command/api'
