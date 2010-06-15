module DbAgile
  class Engine
    module Facts
      
      # Checks if a fact is true or not
      def fact?(table, tuple)
        table_exists?(table) and exists?(table, tuple)
      end
      
      # Returns a fact or a default one
      def fact(table, proj, default = {})
        if table_exists?(table)
          raise "Projection tuple must include a key" unless is_key?(table, proj.keys)
          dataset(table, proj).to_a[0] || default
        else
          default
        end
      end
      
      # Asserts that a fact exists
      def fact!(table, tuple)
        case tuple
          when Array
            tuple.each{|t| fact!(table, t) }
          when Hash
            define(table, tuple_heading(tuple))
            key = tuple_key(tuple, keys(table))
            if exists?(table, key)
              update(table, key, tuple)
            else
              insert(table, tuple)
            end
        end
      end
      
    end # module Facts
  end # class Engine
end # module DbAgile