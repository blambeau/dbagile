module DbAgile
  class Engine
    module Queries
      
      # Does a tuple exists in the database?
      def exists?(table, tuple)
        database.exists?(table, tuple)
      end
      
      # Sends a SQL query to the database
      def sql(str)
        if str =~ /^\s*(SELECT|select)/
          database.dataset(query)
        else
          database.direct_sql(cmd)
        end
      end
      
    end # module Queries
  end # class Engine
end # module DbAgile