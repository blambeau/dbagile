module DbAgile
  module IO
    module CSV

      # Normalizes CSV options from DBAgile options
      def extract_csv_options(options)
        res = options.dup.delete_if{|key,value| !FasterCSV::DEFAULT_OPTIONS.key?(key)}
        if res[:headers]
          res[:write_headers] = true 
          res[:return_headers] = true 
        end
        res
      end
      module_function :extract_csv_options

      #
      # Outputs some data as a CSV string.
      #
      # @return [...] the buffer itself
      #
      def to_csv(data, columns, buffer = "", options = {})
        require 'faster_csv'
        
        # Creates a CSV outputter with options
        csv = FasterCSV.new(buffer, extract_csv_options(options))
        
        # Write header if required
        csv << columns if options[:headers]
        
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
      
      # 
      # If a block is given yields it with each tuple that can be loaded from
      # the CSV input and returns nil. Otherwise, reads the CSV input and returns
      # an array of tuples. 
      #
      def from_csv(input, options = {})
        require 'faster_csv'
        
        # Creates a CSV inputer with options
        csv = FasterCSV.new(input, extract_csv_options(options))
        csv.header_convert(:symbol)
        csv.convert{|field| options[:type_system].parse_literal(field)} if options[:type_system]
        
        # Load data now
        ts = options[:type_system]
        tuples = []
        csv.each do |row|
          next if row.header_row?
          tuple = row.to_hash
          if block_given?
            yield(tuple)
          else
            tuples << tuple
          end
        end
      end
      module_function :from_csv
      
    end # module CSVTools
  end # module IO
end # module DbAgile