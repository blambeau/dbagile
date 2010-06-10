require 'dbagile/adapter/contract'
require 'dbagile/adapter/delegate'
module DbAgile
  class Adapter
    include DbAgile::Adapter::Contract
  end # class Adapter
end # module DbAgile
require 'dbagile/adapter/memory_adapter'
require 'dbagile/adapter/sequel_adapter'
