require 'optparse'
require 'fileutils'
require 'dbagile/command/robust'
require 'dbagile/command/class_methods'
module DbAgile
  class Command
    include ::DbAgile::Command::Robust
    include ::DbAgile::Environment::Delegator
    extend ::DbAgile::Command::ClassMethods
    
    ##############################################################################
    ### Instance variables and construction
    ##############################################################################
    
    # Command execution environment
    attr_reader :environment
     
    # Creates an empty command instance
    def initialize(env)
      @environment = env
      set_default_options
    end
    
    # Returns command name
    def command_name
      Command::command_name_of(self.class)
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
      
    # Returns commands category
    def category
      raise "Command.category should be overriden by subclasses"
    end
      
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
    rescue Exception => ex
      environment.on_error(self, ex)
      environment
    end
    
    # Runs the command without catching any error
    def unsecure_run(requester_file, argv)
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

# :dba category
require 'dbagile/command/dba'
require 'dbagile/command/help'
require 'dbagile/command/history'
require 'dbagile/command/replay'

# :configuration category
require 'dbagile/command/list'
require 'dbagile/command/ping'
require 'dbagile/command/use'
require 'dbagile/command/add'
require 'dbagile/command/rm'

# :io category
require 'dbagile/command/show'
require 'dbagile/command/export'
require 'dbagile/command/import'

# :sql category
require 'dbagile/command/sql'

# :restful category
require 'dbagile/command/webtools'

# Build Command API now
require 'dbagile/command/api'
