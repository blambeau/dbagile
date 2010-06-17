require 'dbagile/adapter/errors'
require 'dbagile/adapter/tools'
module DbAgile
  class Adapter
    include DbAgile::Contract::Full
    include DbAgile::Adapter::Tools
    
    # Builds an adapter instance from an URI
    def self.factor(uri, options = {})
      return uri if uri.kind_of?(Adapter)
      case uri
        when /^memory:\/\//
          DbAgile::MemoryAdapter.new
        else
          DbAgile::SequelAdapter.new(uri, options)
      end
    end
    def self.[](*args) factor(*args) end
    
  end # class Adapter
end # module DbAgile
require 'dbagile/adapter/memory'
require 'dbagile/adapter/sequel'
