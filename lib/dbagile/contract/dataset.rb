module DbAgile
  module Contract
    module Dataset
      
      #
      # Outputs this dataset as a CSV string.
      #
      # @return [...] the buffer itself
      #
      def to_csv(buffer = "", options = {})
        # normalize options
        options[:headers] = true if options[:write_headers]
        
        # retrieve columns
        cs = self.columns
        
        # Creates a CSV outputter with options
        csv = FasterCSV.new(buffer, options)
        
        # Write header if required
        csv << columns if options[:write_headers]
        
        # Write tuples now
        each do |row|
          csv << columns.collect{|c| row[c]}
        end
        buffer
      end
      
    end # module Dataset
  end # module Contract
end # module DbAgile