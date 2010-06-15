module DbAgile
  class Engine
    module Schema
      
      # ReadOnly methods ###########################################################
      
      # Returns true if a table exists, false otherwise
      def table_exists?(table_name)
        database.has_table?(table_name)
      end
      
      # Returns the column names of a table
      def colnames(table_name)
        database.column_names(table_name, true)
      end
      
      # Returns true if a table exists, false otherwise
      def keys(table_name)
        database.keys(table_name)
      end
      
      # Returns true if a table exists, false otherwise
      def is_key?(table_name, columns)
        !!keys(table_name).find{|key| (key -= columns).empty?}
      end
      
      # Update methods #############################################################
      
      # Executes on main signature
      def define(table_name, heading)
        if table_exists?(table_name)
          existing_columns = database.column_names(table_name)
          missing_columns = heading.delete_if{|k,v| existing_columns.include?(k)}
          database.add_columns(table_name, missing_columns) unless missing_columns.empty?
        else
          database.create_table(table_name, heading)
        end
      end
      
      # Adds a candidate key to a given table
      def key!(table_name, columns)
        engine.connected!
        engine.columns_exist!(table_name, columns)
        engine.database.key!(table_name, columns)
      end
      
      # To be moved methods ########################################################
      
      # Uses a given pluging in the main chain
      def use(plugin, *args)
        plugin = DbAgile::Plugin.const_get(plugin) if plugin.kind_of?(Symbol)
        database.unshift_main_delegate(plugin, *args)
        true
      end
      
    end # module Schema
  end # class Engine
end # module DbAgile
