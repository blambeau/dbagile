module DbAgile
  class Engine
    module Data
      
      # Inserts some tuples inside a table
      def insert(table, tuples)
        has_transaction!
        case tuples
          when Hash
            transaction.insert(table, tuples)
          when Array
            tuples.collect do |t|
              transaction.insert(table, t)
            end
        end
      end

      # Inserts some tuples inside a table
      def delete(table, proj = {})
        has_transaction!
        transaction.delete(table, proj)
      end
      
      # Updates some tuples of a table
      def update(table, proj = {}, update = {})
        has_transaction!
        transaction.update(table, proj, update)
      end
      
    end # module Data
  end # class Engine
end # module DbAgile