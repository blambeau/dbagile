module DbAgile
  module Contract
    module Dataset
      
      #
      # Outputs this dataset as a CSV string.
      #
      # @return [...] the buffer itself
      #
      def to_csv(buffer = "", options = {})
        require 'faster_csv'
        
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
      
      # 
      # Outputs this dataset as a JSON string
      #
      # @return [...] the buffer itself
      #
      def to_json(buffer = "", options = {})
        require "json"
        if options[:pretty]
          buffer << JSON::pretty_generate(self.to_a)
        else
          buffer << JSON::fast_generate(self.to_a)
        end
        buffer
      end
      
      # 
      # Outputs this dataset as a Ruby Array of hashes
      #
      # @return [...] the buffer itself
      #
      def to_ruby(buffer = "", options = {})
        buffer << "["
        first = true
        each{|t| 
          buffer << (first ? "\n  " : ",\n  ")
          buffer << t.inspect
          first = false
        }
        buffer << "\n]"
      end
      
    end # module Dataset
  end # module Contract
end # module DbAgile