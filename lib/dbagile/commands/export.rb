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
      
      # Options for CSV output
      attr_accessor :csv_options
      
      # Creates a command instance
      def initialize
        super
        self.format = 'csv'
        self.csv_options = {}
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
        opt.on("--include-header", "-h", "Flush columns names as first line") do
          self.csv_options[:write_headers] = true
        end
        opt.on("--separator=C", "Use C as columns separator character") do |value|
          self.csv_options[:col_sep] = value
        end
        opt.on("--quote=C", "Use C as quoting character") do |value|
          self.csv_options[:quote_char] = value
        end
        opt.on("--force-quotes", "Force quoting?") do 
          self.csv_options[:force_quotes] = true
        end 
        opt.on("--skip-blanks", "Skip blank lines?") do 
          self.csv_options[:skip_blanks] = true
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
          with_io{|io|
            ds = config.connect.dataset(self.dataset)
            ds.to_csv(io, csv_options)
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