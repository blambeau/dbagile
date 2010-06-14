module DbAgile
  class Engine
    module Facts
      
      # Checks if a fact is true or not
      def fact?(table, tuple)
        table_exists?(table) and exists?(table, tuple)
      end
      
      # Asserts that a fact exists
      def fact!(table, tuple)
        define(table, tuple_heading(tuple))
        key = tuple_key(tuple, keys(table))
        if exists?(table, key)
          update(table, key, tuple)
        else
          insert(table, tuple)
        end
      end
      
    end # module Facts
  end # class Engine
end # module DbAgile