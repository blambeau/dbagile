module DbAgile
  class Engine
    module Schema
      
      # Executes on main signature
      def define(table_name, heading)
        database.create_table(table_name, heading)
      end
      
      # Adds a candidate key to a given table
      def key!(table_name, columns)
        engine.connected!
        engine.columns_exist!(table_name, columns)
        engine.database.key!(table_name, columns)
      end
      
      # Uses a given pluging in the main chain
      def use(plugin, options = {})
        plugin = DbAgile::Plugin.const_get(plugin) if plugin.kind_of?(Symbol)
        database.__insert_in_main_chain(plugin, options)
        true
      end
      
    end # module Schema
  end # class Engine
end # module DbAgile
