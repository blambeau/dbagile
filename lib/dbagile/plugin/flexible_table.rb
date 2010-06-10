module DbAgile
  class Plugin
    #
    # Makes a table flexible in the sense that new columns are automatically
    # added when not existing at insert time.
    #
    class FlexibleTable < Plugin
      
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
      
      private :ensure_columns
    end # class FlexibleTable
  end # class Plugin
end # module DbAgile