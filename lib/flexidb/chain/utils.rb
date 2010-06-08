module FlexiDB
  module Chain
    module Utils
    
      # Returns the heading of a given tuple
      def tuple_heading(tuple)
        heading = {}
        tuple.each_pair{|name, value| heading[name] = value.class unless value.nil?}
        heading
      end
    
    end # module Utils
  end # module Chain
end # module FlexiDB