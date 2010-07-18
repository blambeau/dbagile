module DbAgile
  class Command
    module IOCommons
      
      # Output/input format [ruby, csv, json]
      attr_accessor :format
      
      # Connection options
      attr_accessor :conn_options
      
      # Input/output options
      attr_accessor :io_options
      
      # Dataset whose contents must be shown
      attr_accessor :dataset
      
      # Columns to select
      attr_accessor :select
      
      # Columns to allbut
      attr_accessor :allbut
      
      # Builds default configuration
      def set_default_options
        self.format = :csv
        self.conn_options = {}
        self.io_options = Hash.new{|h,k| h[k] = {}}
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
        opt.on('--format=X', [:csv, :text, :json, :yaml, :ruby],
               "Export dataset in (csv, text, json, yaml, ruby)") do |value|
          self.format = value
        end
        opt.on("--csv",  "Export dataset in csv (default)"){ self.format = :csv }
        opt.on("--text", "Export dataset as a plain text table"){ self.format = :text }
        opt.on("--json", "Export dataset in json"){ self.format = :json }
        opt.on("--yaml", "Export dataset in yaml"){ self.format = :yaml }
        opt.on("--xml",  "Export dataset in xml"){ self.format = :xml }
        opt.on("--ruby", "Export dataset as ruby code"){ self.format = :ruby }
      end
      
      # Adds the format options for input
      def add_input_format_options(opt)
        opt.on('--format=X', [:csv, :json, :yaml, :ruby],
               "Import dataset from (csv, json, yaml, ruby)") do |value|
          self.format = value
        end
        opt.on("--csv",  "Import dataset from csv (default)"){ self.format = :csv }
        opt.on("--json", "Import dataset from json"){ self.format = :json }
        opt.on("--ruby", "Import dataset from ruby code"){ self.format = :ruby }
        opt.on("--yaml", "Import dataset from yaml"){ self.format = :yaml }
      end
      
      # Adds the CSV options
      def add_csv_options(opt)
        opt.on("--headers", "-h", "Read/Write column names on first line") do
          io_options[:csv][:headers] = true
        end
        opt.on("--separator=C", "Use C as column separator character") do |value|
          io_options[:csv][:col_sep] = value
        end
        opt.on("--quote=C", "Use C as quoting character") do |value|
          io_options[:csv][:quote_char] = value
        end
        opt.on("--force-quotes", "Force quoting?") do 
          io_options[:csv][:force_quotes] = true
        end 
        opt.on("--skip-blanks", "Skip blank lines?") do 
          io_options[:csv][:skip_blanks] = true
        end 
        opt.on("--type-system=X", [:ruby], 
               "Read/Write type-safe values for (ruby)") do |value|
          case value
            when :ruby
              require 'sbyc/type_system/ruby'
              io_options[:csv][:type_system] = SByC::TypeSystem::Ruby
              io_options[:csv][:headers] = true unless io_options[:csv].key?(:headers)
              io_options[:csv][:quote_char] = "'" unless io_options[:csv].key?(:quote_char)
              io_options[:csv][:force_quotes] = true unless io_options[:csv].key?(:force_quotes)
            else
              raise ArgumentError, "Unknown type system #{value}"
          end
        end
      end
      alias :add_csv_input_options  :add_csv_options
      alias :add_csv_output_options :add_csv_options
      
      # Adds output JSON options 
      def add_json_output_options(opt)
        opt.on("--[no-]pretty", "Generate a pretty JSON document") do |value|
          io_options[:json][:pretty] = value
        end 
      end
       
      # Adds output TEXT options 
      def add_text_output_options(opt)
        opt.on("--wrap-at=X", Integer,
               "Wraps table after X's character (no wrap by default)") do |x|
          io_options[:text][:wrap_at] = x
        end
        opt.on("--truncate-at=X", Integer,
               "Truncate row lines at X character") do |x|
          io_options[:text][:truncate_at] = x
          io_options[:text][:append_with] = '...'
        end
      end
       
    end # module CSVOptions
  end # class Command
end # module DbAgile