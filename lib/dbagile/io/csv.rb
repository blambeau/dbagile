module DbAgile
  module IO
    module CSV

      #
      # Outputs some data as a CSV string.
      #
      # @return [...] the buffer itself
      #
      def to_csv(data, columns, buffer = "", options = {})
        require 'faster_csv'
        
        # normalize options
        options[:headers] = true if options[:write_headers]
        
        # Creates a CSV outputter with options
        csv_options = options.dup.delete_if{|key,value| !FasterCSV::DEFAULT_OPTIONS.key?(key)}
        csv = FasterCSV.new(buffer, csv_options)
        
        # Write header if required
        csv << columns if options[:write_headers]
        
        # Write tuples now
        if ts = options[:type_system]
          data.each{|row| csv << columns.collect{|c| ts.to_literal(row[c])}}
        else
          data.each{|row| csv << columns.collect{|c| row[c]}}
        end
        
        # Return buffer
        buffer
      end
      module_function :to_csv
      
    end # module CSVTools
  end # module IO
end # module DbAgile