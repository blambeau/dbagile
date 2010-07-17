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
    
  end # class Environment
end # module DbAgile