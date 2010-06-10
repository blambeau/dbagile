module DbAgile
  class Plugin
    #
    # Makes keys flexible by auto detecting and creating keys to create.
    #
    class AgileKeys < Plugin
      
      # Returns default brick options
      def default_options
        {:candidate => /^id$|_id$/}
      end
      
      # Finds and create candidate keys for the table
      def create_candidate_key(table_name, columns)
        return unless match = options[:candidate]
        which = columns.select{|c| match =~ c.to_s}
        return if which.empty?
        key(table_name, which)
      end
      
      # Creates a table with some columns. 
      def create_table(table_name, columns)
        res = delegate.create_table(table_name, columns)
        create_candidate_key(table_name, columns.keys)
        res
      end
      
    end # class AgileTable
  end # class Plugin
end # module DbAgile