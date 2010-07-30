require 'dbagile/environment/robustness'
require 'dbagile/environment/on_error'
require 'dbagile/environment/configuration'
require 'dbagile/environment/console'
require 'dbagile/environment/interactions'
require 'dbagile/environment/delegator'
module DbAgile
  #
  # Defines the contract to be an environment for dbagile.
  #
  class Environment
    include DbAgile::Environment::OnError
    include DbAgile::Environment::Configuration
    include DbAgile::Environment::Console
    include DbAgile::Environment::Interactions
    
    #
    # Creates an Environment instance with two buffers
    #
    def initialize(input_buffer = STDIN, output_buffer = STDOUT)
      @input_buffer, @output_buffer = input_buffer, output_buffer
      @highline = HighLine.new
      @show_backtrace = false
    end
    
    #
    # Duplicates the environment but removes any cached value (repository 
    # and so on)
    #
    def dup
      env = Environment.new(input_buffer, output_buffer)
      env.repository_path = self.repository_path
      env
    end
    
    #
    # Returns the default environment to use.
    #
    # The algorithm implemented tries to locate a repository folder in the
    # following order:
    #
    # - dbagile.idx file in the current directory -> it's parent folder
    # - dbagile folder in the current directory   -> ./dbagile
    # - .dbagile folder in user's home            -> ~/.dbagile
    #
    # If none of those files exists, a default environment will be created
    # mapping to an unexisting repository folder in ~/.dbagile
    #
    # By default, the repository is not loaded at all, and errors can therefore
    # occur later, when the repository will be first accessed. Set 
    # load_repository to true to force immediate load.
    #
    def self.default(load_repository = false)
      # find a root path or return nil
      root_path = if File.exists?("./dbagile.idx")
        "."
      elsif File.exists?("dbagile")
        "dbagile"
      else
        File.join(ENV['HOME'], '.dbagile')
      end

      # Build environment
      env = Environment.new
      env.repository_path = root_path
      return env unless load_repository
      
      # Load repository now
      env.repository
    end
    
    # Convenient method for Environment::default(true)
    def self.default!
      Environment::default(true)
    end
    
  end # class Environment
end # module DbAgile