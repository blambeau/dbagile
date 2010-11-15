module DbAgile
  module Tools
    module Tuple
      
      # Returns the heading of a given tuple
      def tuple_heading(tuple)
        heading = {}
        tuple.each_pair{|name, value| heading[name] = value.class}
        heading
      end
      
      # Checks a tuple heading, displaying a warning message on the 
      # environment if something goes bad...
      def check_tuple_heading(heading, environment)
        heading.each_pair{|k,v|
          if NilClass == v
            environment.say("WARNING: NilClass in heading (type inference failure), using String")
            heading[k] = String
          elsif !DbAgile::RECOGNIZED_DOMAINS.include?(v)
            environment.say("WARNING: Unrecognized domain #{v} in heading, using String")
            heading[k] = String
          end
        }
        heading
      end
      
      # Projects a tuple over some columns
      def tuple_project(tuple, columns)
        proj = {}
        columns.collect{|col| proj[col] = tuple[col]}
        proj
      end
      
      # Checks if a given tuple contains value for at least one
      # key.
      def tuple_has_key?(tuple, keys)
        return false if keys.nil?
        !keys.find{|k| k.all?{|a| !tuple[a].nil? }}.nil?
      end
      
      # Extract the key/value pairs that form a key on a tuple, given 
      # keys information. Returns tuple if no such better tuple can be found.
      def tuple_key(tuple, keys)
        return tuple if keys.nil?
        key = keys.find{|k| k.all?{|a| !tuple[a].nil? }}
        key.nil? ? tuple : tuple_project(tuple, key)
      end
      
      # Converts a tuple to a query string
      def tuple_to_querystring(tuple)
        tuple.collect{|k,v| "#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}"}.reverse.join('&')
      end
      
    end # module Tools
  end # class Adapter
end # module DbAgile