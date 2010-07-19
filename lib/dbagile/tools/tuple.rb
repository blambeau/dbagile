module DbAgile
  module Tools
    module Tuple
      
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
      
      # Extract the key/value pairs that form a key on a tuple, given 
      # keys information. Returns tuple if no such better tuple can be found.
      def tuple_key(tuple, keys)
        return tuple if keys.nil?
        key = keys.find{|k| k.all?{|a| !tuple[a].nil? }}
        key.nil? ? tuple : tuple_project(tuple, key)
      end
      
    end # module Tools
  end # class Adapter
end # module DbAgile