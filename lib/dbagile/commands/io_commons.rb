module DbAgile
  module Commands
    module IOCommons
      
      # Output/input format [ruby, csv, json]
      attr_accessor :format
      
      # Options for CSV input/output
      attr_accessor :csv_options
      
      # Options for JSON input/output
      attr_accessor :json_options
      
      # Options for Ruby input/output
      attr_accessor :ruby_options

      # Dataset whose contents must be shown
      attr_accessor :dataset
      
      # Builds default configuration
      def install_default_configuration
        self.format = 'csv'
        self.csv_options = {}
        self.json_options = {}
        self.ruby_options = {}
      end

      # Adds the format options
      def add_io_format_options(opt)
        opt.on("--csv", "Read/Write dataset as csv string (default)") do
          self.format = 'csv'
        end
        opt.on("--json", "Read/Write dataset as json string") do
          self.format = 'json'
        end
        opt.on("--ruby", "Read/Write dataset as ruby code (array of hashes)") do
          self.format = 'ruby'
        end
      end
      
      # Adds the CSV options
      def add_csv_options(opt)
        opt.on("--include-header", "-h", "Read/Write column names on first line") do
          csv_options[:write_headers] = true
        end
        opt.on("--separator=C", "Use C as column separator character") do |value|
          csv_options[:col_sep] = value
        end
        opt.on("--quote=C", "Use C as quoting character") do |value|
          csv_options[:quote_char] = value
        end
        opt.on("--force-quotes", "Force quoting?") do 
          csv_options[:force_quotes] = true
        end 
        opt.on("--skip-blanks", "Skip blank lines?") do 
          csv_options[:skip_blanks] = true
        end 
        opt.on("--type-system=X", "Use SByC::TypeSystem::X when reading/writing type-safe values (ruby)") do |value|
          case value
            when 'ruby'
              require 'sbyc/type_system/ruby'
              csv_options[:type_system] = SByC::TypeSystem::Ruby
              csv_options[:quote_char] = "'" unless csv_options.key?(:quote_char)
              csv_options[:force_quotes] = true unless csv_options.key?(:force_quotes)
            else
              exit("Unknown type system #{value}", false)
          end
        end
      end
      alias :add_csv_input_options  :add_csv_options
      alias :add_csv_output_options :add_csv_options
      
      # Adds output JSON options 
      def add_json_output_options(opt)
        opt.on("--pretty", "Generate a pretty JSON document") do 
          json_options[:pretty] = true
        end 
      end
       
    end # module CSVOptions
  end # module Commands
end # module DbAgile