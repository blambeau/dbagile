module DbAgile
  class Engine
    module Data
      
      # Inserts some tuples inside a table
      def insert(table, tuples)
        case tuples
          when Hash
            database.insert(table, tuples)
          when Array
            tuples.collect do |t|
              database.insert(table, t)
            end
        end
      end
      
    end # module Data
  end # class Engine
end # module DbAgile