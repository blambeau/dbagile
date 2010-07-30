require 'readline'
require 'dbagile/environment/delegator'
require 'dbagile/environment/interactions'
require 'dbagile/environment/robustness'
require 'dbagile/environment/configuration'
require 'dbagile/environment/console'
module DbAgile
  #
  # Defines the contract to be an environment for dbagile.
  #
  class Environment
    include DbAgile::Environment::Interactions
    include DbAgile::Environment::Robustness
    include DbAgile::Environment::Configuration
    include DbAgile::Environment::History
    include DbAgile::Environment::Console
    
    # Creates an Environment instance with two buffers
    def initialize(input_buffer = STDIN, output_buffer = STDOUT)
      @input_buffer, @output_buffer = input_buffer, output_buffer
      @highline = HighLine.new
      @show_backtrace = false
    end
    
    # Duplicates the environment but removes any cached value (repository 
    # and so on)
    def dup
      env = Environment.new
      env.input_buffer = self.input_buffer
      env.output_buffer = self.output_buffer
      env.repository_path = self.repository_path
      env
    end
    
  end # class Environment
end # module DbAgile