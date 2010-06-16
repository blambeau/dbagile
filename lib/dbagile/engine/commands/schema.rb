module DbAgile
  class Engine
    module Schema
      
      # ReadOnly methods ###########################################################
      
      # Returns true if a table exists, false otherwise
      def table_exists?(table_name)
        connection.has_table?(table_name)
      end
      
      # Returns the column names of a table
      def colnames(table_name)
        connection.column_names(table_name, true)
      end
      
      # Returns true if a table exists, false otherwise
      def keys(table_name)
        connection.keys(table_name)
      end
      
      # Returns true if a table exists, false otherwise
      def is_key?(table_name, columns)
        !!keys(table_name).find{|key| (key -= columns).empty?}
      end
      
      # Update methods #############################################################
      
      # Executes on main signature
      def define(table_name, heading)
        has_transaction!
        if table_exists?(table_name)
          existing_columns = connection.column_names(table_name)
          missing_columns = heading.delete_if{|k,v| existing_columns.include?(k)}
          transaction.add_columns(table_name, missing_columns) unless missing_columns.empty?
        else
          transaction.create_table(table_name, heading)
        end
      end
      
      # Adds a candidate key to a given table
      def key!(table_name, columns)
        engine.connected!
        has_transaction!
        engine.columns_exist!(table_name, columns)
        transaction.key!(table_name, columns)
      end
      
      # To be moved methods ########################################################
      
      # Plugs something in the chain
      def plug(*args)
        connection.plug(*args)
        puts connection.inspect
      end
      
    end # module Schema
  end # class Engine
end # module DbAgile
