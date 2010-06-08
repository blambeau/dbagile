module FlexiDB
  module Chain
    #
    # Makes a table flexible in the sense that new columns are automatically
    # added when not existing at insert time.
    #
    class FlexibleTable < Brick
      
      # Returns default brick options
      def default_options
        {:create_table_when_not_exists => true}
      end
      
      # Ensures the columns of some table
      def ensure_columns(table, tuple)
        heading = tuple_heading(tuple)
        adapter.with_global_lock{|a| 
          if a.has_table?(table)
            existing_columns = a.column_names(table)
            missing_columns = heading.delete_if{|k,v| existing_columns.include?(k)}
            a.add_columns(table, missing_columns) unless missing_columns.empty?
          elsif options[:create_table_when_not_exists]
            a.create_table(table, heading)
          end
        }
      end
      
      # Makes an insertion inside a table
      def insert(table, tuple)
        ensure_columns(table, tuple)
        delegate.insert(table, tuple)
      end
      
    end # class FlexTable
  end # module Chain
end # module FlexiDB