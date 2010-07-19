require 'dbagile/adapter/errors'
require 'dbagile/adapter/tools'
module DbAgile
  class Adapter
    include DbAgile::Contract::Utils::Full
    
    # Builds an adapter instance from an URI
    def self.factor(uri, options = {})
      return uri if uri.kind_of?(Adapter)
      DbAgile::SequelAdapter.new(uri, options)
    end
    def self.[](*args) factor(*args) end
    
  end # class Adapter
end # module DbAgile
require 'dbagile/adapter/sequel'
