module DbAgile
  # 
  # Defines common contract of all plugins inside the adapter chain
  #
  class Plugin
    include DbAgile::Contract::Utils::Delegate
    include DbAgile::Tools::Tuple
    
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
