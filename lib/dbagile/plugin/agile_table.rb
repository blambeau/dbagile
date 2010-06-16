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
      def ensure_columns(transaction, table, tuple)
        heading = tuple_heading(tuple)
        if has_table?(table)
          existing_columns = column_names(table)
          missing_columns = heading.delete_if{|k,v| existing_columns.include?(k)}
          add_columns(transaction, table, missing_columns) unless missing_columns.empty?
        elsif options[:create_table]
          create_table(transaction, table, heading)
        end
      end
      
      # Makes an insertion inside a table
      def insert(transaction, table, tuple)
        ensure_columns(transaction, table, tuple)
        delegate.insert(transaction, table, tuple)
      end
      
      # Makes an update inside a table
      def update(transaction, table, proj, update)
        ensure_columns(transaction, table, update)
        delegate.update(transaction, table, proj, update)
      end
      
      private :ensure_columns
    end # class AgileTable
  end # class Plugin
end # module DbAgile