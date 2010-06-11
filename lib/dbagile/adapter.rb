require 'dbagile/adapter/errors'
require 'dbagile/adapter/contract'
require 'dbagile/adapter/delegate'
require 'dbagile/adapter/tools'
module DbAgile
  class Adapter
    include DbAgile::Adapter::Contract
    include DbAgile::Adapter::Tools
  end # class Adapter
end # module DbAgile
require 'dbagile/adapter/memory'
require 'dbagile/adapter/sequel'
