module FlexiDB
  module Utils
    
    # Returns the heading of a given tuple
    def heading_of(tuple)
      heading = {}
      tuple.each_pair{|name, value| heading[name] = value.class unless value.nil?}
      heading
    end
    module_function :heading_of
    
  end # module Utils
end # module FlexiDB