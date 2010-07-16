require 'dbagile/environment/interactions'
require 'dbagile/environment/robustness'
module DbAgile
  #
  # Defines the contract to be an environment for dbagile.
  #
  class Environment
    include DbAgile::Environment::Interactions
    include DbAgile::Environment::Robustness
    
  end # class Environment
end # module DbAgile