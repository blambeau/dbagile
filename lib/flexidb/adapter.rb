require 'flexidb/adapter/contract'
require 'flexidb/adapter/delegate'
module FlexiDB
  class Adapter
    include FlexiDB::Adapter::Contract
  end # class Adapter
end # module FlexiDB
require 'flexidb/adapter/memory_adapter'
require 'flexidb/adapter/sequel_adapter'
