module DbAgile
  class Plugin
    #
    # Makes a table agile, i.e. ensuring that new columns are automatically
    # added when not existing at insert time.
    #
    class AgileTable < Plugin
      
      # Returns default brick options
      def default_options
        {:create_table => true}
      end
      
      # Ensures the columns of some table
      def ensure_columns(table, tuple)
        heading = tuple_heading(tuple)
        if has_table?(table)
          existing_columns = column_names(table)
          missing_columns = heading.delete_if{|k,v| existing_columns.include?(k)}
          add_columns(table, missing_columns) unless missing_columns.empty?
        elsif options[:create_table]
          create_table(table, heading)
        end
      end
      
      # Makes an insertion inside a table
      def insert(table, tuple)
        ensure_columns(table, tuple)
        delegate.insert(table, tuple)
      end
      
      # Makes an update inside a table
      def update(table, proj, update)
        ensure_columns(table, update)
        delegate.update(table, proj, update)
      end
      
      private :ensure_columns
    end # class AgileTable
  end # class Plugin
end # module DbAgile