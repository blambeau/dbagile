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

      # Options for Text output
      attr_accessor :text_options

      # Dataset whose contents must be shown
      attr_accessor :dataset
      
      # Columns to select
      attr_accessor :select
      
      # Columns to allbut
      attr_accessor :allbut
      
      # Builds default configuration
      def install_default_configuration
        self.format = :csv
        self.csv_options = {}
        self.json_options = {}
        self.ruby_options = {}
        self.text_options = {}
      end
      
      # Adds the select/allbut options
      def add_select_options(opt)
        opt.on('--select x,y,z', Array,
               "Select x, y, z columns only") do |value|
          self.select = value.collect{|c| c.to_sym}
        end
        opt.on('--allbut x,y,z', Array,
               "Select all but x, y, z columns") do |value|
          self.allbut = value.collect{|c| c.to_sym}
        end
      end

      # Adds the format options for output
      def add_output_format_options(opt)
        opt.on('--format=X', [:csv, :text, :json, :ruby],
               "Export dataset in (csv, text, json, ruby)") do |value|
          self.format = value
        end
        opt.on("--csv",  "Export dataset in csv (default)"){ self.format = :csv }
        opt.on("--text", "Export dataset as a plain text table"){ self.format = :text }
        opt.on("--json", "Export dataset in json"){ self.format = :json }
        opt.on("--ruby", "Export dataset as ruby code (Array of Hash(es))"){ self.format = :ruby }
      end
      
      # Adds the format options for input
      def add_input_format_options(opt)
        opt.on('--format=X', [:csv, :json, :ruby],
               "Import dataset from (csv, json, ruby)") do |value|
          self.format = value
        end
        opt.on("--csv",  "Import dataset from csv (default)"){ self.format = :csv }
        opt.on("--json", "Import dataset from json"){ self.format = :json }
        opt.on("--ruby", "Import dataset from ruby code (Array of Hash(es))"){ self.format = :ruby }
      end
      
      # Adds the CSV options
      def add_csv_options(opt)
        opt.on("--headers", "-h", "Read/Write column names on first line") do
          csv_options[:headers] = true
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
        opt.on("--type-system=X", [:ruby], 
               "Read/Write type-safe values for (ruby)") do |value|
          case value
            when :ruby
              require 'sbyc/type_system/ruby'
              csv_options[:type_system] = SByC::TypeSystem::Ruby
              csv_options[:headers] = true unless csv_options.key?(:headers)
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
       
      # Adds output TEXT options 
      def add_text_output_options(opt)
        opt.on("--wrap-at=X", Integer,
               "Wraps table after X's character (no wrap by default)") do |x|
          text_options[:wrap_at] = x
        end
        opt.on("--truncate-at=X", Integer,
               "Truncate row lines at X character") do |x|
          text_options[:truncate_at] = x
          text_options[:append_with] = '...'
        end
      end
       
    end # module CSVOptions
  end # module Commands
end # module DbAgile