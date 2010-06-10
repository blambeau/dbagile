module DbAgile
  class Adapter
    module Tools
      
      # Returns the heading of a given tuple
      def tuple_heading(tuple)
        heading = {}
        tuple.each_pair{|name, value| heading[name] = value.class unless value.nil?}
        heading
      end
      
      # Projects a tuple over some columns
      def tuple_project(tuple, columns)
        proj = {}
        columns.collect{|col| proj[col] = tuple[col]}
        proj
      end
      
    end # module Tools
  end # class Adapter
end # module DbAgile