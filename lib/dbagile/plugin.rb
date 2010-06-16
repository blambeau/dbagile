module DbAgile
  # 
  # Defines common contract of all plugins inside the adapter chain
  #
  class Plugin
    include Adapter::Delegate
    include DbAgile::Adapter::Tools
    
    # Plugin options
    attr_reader :options
    
    # Returns an instance
    def self.[](*args)
      self.new(*args)
    end
    
    # Creates a brick instance with a given delegate
    def initialize(options = {})
      @options = default_options.merge(options)
    end
    
    # Returns default brick options
    def default_options
      {}
    end
    
    private :default_options
  end # class Plugin
end # module DbAgile
require 'dbagile/plugin/agile_table'
require 'dbagile/plugin/agile_keys'
require 'dbagile/plugin/trace'
require 'dbagile/plugin/touch'
require 'dbagile/plugin/defaults'