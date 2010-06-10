module DbAgile
  # 
  # Defines common contract of all plugins inside the adapter chain
  #
  class Plugin
    include Adapter::Delegate
    
    # Plugin options
    attr_reader :options
    
    # Next brick in the chain
    attr_reader :delegate
    
    # Creates a brick instance with a given delegate
    def initialize(delegate, options = {})
      @options = default_options.merge(options)
      @delegate = delegate
    end
    
    # Returns default brick options
    def default_options
      {}
    end
    
    # Returns the heading of a given tuple
    def tuple_heading(tuple)
      heading = {}
      tuple.each_pair{|name, value| heading[name] = value.class unless value.nil?}
      heading
    end
  
    private :default_options
    private :tuple_heading
  end # class Plugin
end # module DbAgile
require 'dbagile/plugin/flexible_table'
require 'dbagile/plugin/defaults'