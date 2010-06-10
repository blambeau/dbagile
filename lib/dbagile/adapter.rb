require 'flexidb/adapter/contract'
require 'flexidb/adapter/delegate'
module DbAgile
  class Adapter
    include DbAgile::Adapter::Contract
  end # class Adapter
end # module DbAgile
require 'flexidb/adapter/memory_adapter'
require 'flexidb/adapter/sequel_adapter'
