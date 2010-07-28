require 'optparse'
require 'fileutils'
require 'dbagile/command/robust'
require 'dbagile/command/class_methods'
module DbAgile
  class Command
    include ::DbAgile::Command::Robust
    include ::DbAgile::Environment::Delegator
    extend ::DbAgile::Command::ClassMethods
    
    # Command categories
    CATEGORIES = [:dba, :repo, :sql, :schema, :bulk, :web]
    
    # Names of the categories
    CATEGORY_NAMES = {
      :dba           => "Main commands:",
      :repo          => "Repository management:",
      :bulk          => "Import/Export management:",
      :sql           => "SQL:",
      :schema        => "Database schema:",
      :web           => "Database and the web:"
    }

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
      self.class.command_name
    end
    
    # Returns command summary
    def summary
      self.class.summary || ""
    end
    
    # Returns command summary
    def usage
      self.class.usage || ""
    end
    alias :banner :usage
    
    def description
      self.class.description || ""
    end
    
    ##############################################################################
    ### About options
    ##############################################################################
    
    # Parses commandline options provided as an array of Strings.
    def options
      @options ||= OptionParser.new do |opt|
        opt.program_name = File.basename $0
        opt.version = DbAgile::VERSION
        opt.release = nil
        opt.summary_indent = ' ' * 2
        opt.banner = self.banner
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
    
  end # class Command
end # module DbAgile

# :dba category
require 'dbagile/command/dba'
require 'dbagile/command/help'
require 'dbagile/command/history'
require 'dbagile/command/replay'

# :repo category
require 'dbagile/command/repo'

# :bulk category
require 'dbagile/command/bulk'

# :sql category
require 'dbagile/command/sql'

# :schema category
require 'dbagile/command/schema'

# :web category
require 'dbagile/command/web'

# Build Command API now
require 'dbagile/command/api'
