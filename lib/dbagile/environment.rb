require 'dbagile/environment/robustness'
require 'dbagile/environment/on_error'
require 'dbagile/environment/buffering'
require 'dbagile/environment/interactions'
require 'dbagile/environment/repository'
require 'dbagile/environment/delegator'
module DbAgile
  #
  # Defines the contract to be an environment for dbagile.
  #
  class Environment
    include DbAgile::Environment::OnError
    include DbAgile::Environment::Buffering
    include DbAgile::Environment::Interactions
    include DbAgile::Environment::Repository
    
    #
    # Creates a default Environment instance with following options:
    # 
    # - repository_path -> what Environment::default_repository_path returns
    # - input_buffer    -> STDIN
    # - output_buffer   -> STDOUT
    # - interactive?    -> true
    # - asking_buffer   -> STDIN
    # - message_buffer  -> STDERR
    # - show_backtrace  -> false
    #
    def initialize
      @repository_path = Environment::default_repository_path
      @input_buffer    = STDIN
      @output_buffer   = STDOUT
      @interactive     = true
      @asking_buffer   = STDIN
      @message_buffer  = STDERR
      @show_backtrace  = false
    end
    
    #
    # Duplicates the environment but removes any cached value (repository 
    # and so on)
    #
    def dup
      env = Environment.new
      env.repository_path = self.repository_path
      env.input_buffer    = self.input_buffer
      env.output_buffer   = self.output_buffer
      env.interactive     = self.interactive?
      env.asking_buffer   = self.asking_buffer
      env.message_buffer  = self.message_buffer
      env.show_backtrace  = self.show_backtrace
      env
    end
    
    # 
    # Returns the default path to use for a repository.
    #
    # The algorithm implemented tries to locate a repository folder in the
    # following order:
    #
    # - dbagile.idx file in the current directory -> it's parent folder
    # - dbagile folder in the current directory   -> ./dbagile
    # - .dbagile folder in user's home            -> ~/.dbagile
    #
    # If none of those files exists, ~/.dbagile is returned
    #
    def self.default_repository_path
      if File.exists?("./dbagile.idx")
        "."
      elsif File.exists?("dbagile")
        "dbagile"
      else
        File.join(ENV['HOME'], '.dbagile')
      end
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
      env = Environment.new
      if load_repository
        env.repository
      end
      env
    end
    
    #
    # Convenient method for Environment::default(true)
    #
    def self.default!
      Environment::default(true)
    end
    
  end # class Environment
end # module DbAgile