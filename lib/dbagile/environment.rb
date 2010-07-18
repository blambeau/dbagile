require 'readline'
require 'dbagile/environment/interactions'
require 'dbagile/environment/robustness'
require 'dbagile/environment/configuration'
require 'dbagile/environment/history'
module DbAgile
  #
  # Defines the contract to be an environment for dbagile.
  #
  class Environment
    include DbAgile::Environment::Interactions
    include DbAgile::Environment::Robustness
    include DbAgile::Environment::Configuration
    include DbAgile::Environment::History
    
    # Creates an Environment instance with two buffers
    def initialize(input_buffer = STDIN, output_buffer = STDOUT)
      @input_buffer, @output_buffer = input_buffer, output_buffer
    end
    
    # Duplicates the environment but removes any cached value (config_file 
    # and so on)
    def dup
      env = Environment.new
      env.input_buffer = self.input_buffer
      env.output_buffer = self.output_buffer
      env.config_file_path = self.config_file_path
      env.history_file_path = self.history_file_path
      env
    end
    
  end # class Environment
end # module DbAgile