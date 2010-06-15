module DbAgile
  class Engine
    module Queries
      
      # Does a table or query leads empty dataset?
      def empty?(table_or_query)
        dataset = dataset(table_or_query)
        if dataset.respond_to?(:empty?)
          dataset.empty? 
        else 
          dataset.count == 0
        end
      end
      
      # Does a tuple exists in the database?
      def exists?(table, tuple = {})
        database.exists?(table, tuple)
      end
      
      # Delegated to database
      def dataset(query, proj = nil)
        database.dataset(query, proj)
      end
      
      # Sends a SQL query to the database
      def sql(str)
        case str
          when Symbol, /^[a-z]+$/, /^\s*(SELECT|select)/
            database.dataset(str)
          else
            database.direct_sql(str)
        end
      end
      
    end # module Queries
  end # class Engine
end # module DbAgile