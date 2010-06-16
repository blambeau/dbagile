module DbAgile
  class Plugin
    #
    # Makes keys agile, i.e. auto detects and creates candidate and foreign keys.
    #
    class AgileKeys < Plugin
      
      # Returns default brick options
      def default_options
        {:candidate => /^id$|_id$/}
      end
      
      # Finds and create candidate keys for the table
      def create_candidate_key(transaction, table_name, columns)
        puts "Will create a candidate key #{table_name} for #{columns.inspect}"
        return unless match = options[:candidate]
        which = columns.select{|c| match =~ c.to_s}
        return if which.empty?
        key!(transaction, table_name, which)
      end
      
      # Creates a table with some columns. 
      def create_table(transaction, table_name, columns)
        puts "Create table on AgileKeys"
        res = delegate.create_table(transaction, table_name, columns)
        create_candidate_key(transaction, table_name, columns.keys)
        res
      end
      
    end # class AgileTable
  end # class Plugin
end # module DbAgile