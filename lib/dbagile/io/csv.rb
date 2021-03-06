module DbAgile
  module IO
    module CSV
      extend IO::TypeSafe
      
      # Normalizes CSV options from DBAgile options
      def normalize_options(options)
        if options[:type_system]
          options[:headers] = true unless options.key?(:headers)
          options[:quote_char] = "'" unless options.key?(:quote_char)
          options[:force_quotes] = true unless options.key?(:force_quotes)
        end
        if options[:headers]
          options[:write_headers] = true 
          options[:return_headers] = true 
        end
        options
      end
      module_function :normalize_options

      # Makes the CSV require, depending on Ruby version
      def build_csv_instance(io, options)
        if RUBY_VERSION >= "1.9.0"
          require 'csv'
          options = normalize_options(options)
          csv_options = options.dup.delete_if{|key,value| !::CSV::DEFAULT_OPTIONS.key?(key)}
          [::CSV.new(io, csv_options), options]
        else
          require 'faster_csv'
          options = normalize_options(options)
          csv_options = options.dup.delete_if{|key,value| !FasterCSV::DEFAULT_OPTIONS.key?(key)}
          [FasterCSV.new(io, csv_options), options]
        end
      end
      module_function :build_csv_instance

      #
      # Outputs some data as a CSV string.
      #
      # @return [...] the buffer itself
      #
      def to_csv(data, columns, buffer = "", options = {})
        # Creates a CSV outputter with options
        csv, options = build_csv_instance(buffer, options)
        
        # Write header if required
        if options[:headers]
          if ts = options[:type_system]
            csv << columns.collect{|c| ts.to_literal(c)}
          else
            csv << columns
          end
        end
        
        # Write tuples now
        with_type_safe_relation(data, options) do |tuple|
          csv << columns.collect{|c| tuple[c]}
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
        # Creates a CSV inputer with options
        csv, options = build_csv_instance(input, options)
        if ts = options[:type_system]
          converter = lambda{|field| ts.parse_literal(field)}
          csv.header_convert(&converter)
          csv.convert(&converter)
        end
        
        # Load data now
        ts = options[:type_system]
        if block_given?
          csv.each do |row|
            next if row.header_row?
            yield(row.to_hash)
          end
        else
          tuples = []
          csv.each do |row|
            next if row.header_row?
            tuples << row.to_hash
          end
          tuples
        end
      end
      module_function :from_csv
      
    end # module CSVTools
  end # module IO
end # module DbAgile