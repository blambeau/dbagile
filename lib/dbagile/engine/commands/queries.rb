module DbAgile
  class Engine
    module Queries
      
      # Does a tuple exists in the database?
      def exists?(table, tuple)
        database.exists?(table, tuple)
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