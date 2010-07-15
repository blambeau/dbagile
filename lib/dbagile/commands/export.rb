module DbAgile
  module Commands
    #
    # Exports the content of a table in different formats
    #
    class Export < ::DbAgile::Commands::Command
      
      # Output format [ruby, csv, json]
      attr_accessor :format
      
      # Output file to use
      attr_accessor :output_file
      
      # Dataset whose contents must be shown
      attr_accessor :dataset
      
      # Options for CSV/JSON output
      attr_accessor :output_options
      
      # Creates a command instance
      def initialize
        super
        self.format = 'csv'
        self.output_options = {}
      end
      
      # Returns the command banner
      def banner
        "usage: dba export [OPTIONS] DATASET"
      end

      # Short help
      def short_help
        "Export contents of a table/view/query as ruby/csv/json"
      end
      
      # Shows the help
      def show_help
        info banner
        info ""
        info short_help
        info ""
      end

      # Contribute to options
      def add_options(opt)
        opt.separator nil
        opt.separator "Output options:"
        opt.on("--output=FILE", "-o", "Flush output in FILE (stdout by default)") do |value|
          self.output_file = value
        end
        opt.on("--csv", "Output dataset as csv string (default)") do
          self.format = 'csv'
        end
        opt.on("--json", "Output dataset as json string") do
          self.format = 'json'
        end
        opt.on("--ruby", "Output dataset as ruby code (array of hashes)") do
          self.format = 'ruby'
        end
        opt.separator nil
        opt.separator "CSV options:"
        opt.on("--include-header", "-h", "Flush column names as first line") do
          self.output_options[:write_headers] = true
        end
        opt.on("--separator=C", "Use C as column separator character") do |value|
          self.output_options[:col_sep] = value
        end
        opt.on("--quote=C", "Use C as quoting character") do |value|
          self.output_options[:quote_char] = value
        end
        opt.on("--force-quotes", "Force quoting?") do 
          self.output_options[:force_quotes] = true
        end 
        opt.on("--skip-blanks", "Skip blank lines?") do 
          self.output_options[:skip_blanks] = true
        end 
        opt.on("--type-system=X", "Use SByC::TypeSystem::X for generating type-safe values (only ruby is available for now)") do |value|
          case value
            when 'ruby'
              require 'sbyc/type_system/ruby'
              self.output_options[:type_system] = SByC::TypeSystem::Ruby
              self.output_options[:quote_char] = "'" unless self.output_options.key?(:quote_char)
              self.output_options[:force_quotes] = true unless self.output_options.key?(:force_quotes)
            else
              exit("Unknown type system #{value}", false)
          end
        end
        opt.separator nil
        opt.separator "JSON options:"
        opt.on("--pretty", "Generate a pretty JSON document") do 
          self.output_options[:pretty] = true
        end 
      end
      
      # Normalizes the pending arguments
      def normalize_pending_arguments(arguments)
        exit(nil, true) unless arguments.size == 1
        self.dataset = arguments.shift.strip
        unless /select|SELECT/ =~ self.dataset
          self.dataset = self.dataset.to_sym
        end
      end
      
      # Yields the block with the IO object to use for output
      def with_io(&block)
        if self.output_file
          require 'fileutils'
          FileUtils.mkdir_p(File.dirname(self.output_file))
          File.open(self.output_file, "w", &block)
        else
          block.call(STDOUT)
        end
      end
      
      # Executes the command
      def execute_command
        # load the configuration file
        config_file = DbAgile::load_user_config_file(DbAgile::user_config_file, true)
        config = has_config!(config_file)
        
        # Make the job now
        begin
          ds = config.connect.dataset(self.dataset)
          with_io{|io|
            case self.format
              when 'csv'
                ds.to_csv(io, output_options)
              when 'json'
                ds.to_json(io, output_options)
              when 'ruby'
                ds.to_ruby(io, output_options)
            end
          }
        rescue Exception => ex
          puts ex.message
          puts ex.backtrace.join("\n")
          exit(ex.message, false)
        end
      end
      
    end # class List
  end # module Commands
end # module DbAgile