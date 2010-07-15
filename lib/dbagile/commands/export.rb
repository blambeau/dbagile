require 'dbagile/commands/io_commons'
module DbAgile
  module Commands
    #
    # Exports the content of a table in different formats
    #
    class Export < ::DbAgile::Commands::Command
      include ::DbAgile::Commands::IOCommons
      
      # Output file to use
      attr_accessor :output_file
      
      # Creates a command instance
      def initialize
        super
        install_default_configuration
      end
      
      # Returns the command banner
      def banner
        "usage: dba export [OPTIONS] DATASET"
      end

      # Short help
      def short_help
        "Export contents of a table/view/query as ruby/csv/json"
      end
      
      # Contribute to options
      def add_options(opt)
        # Main output options
        opt.separator "\nOutput options:"
        opt.on("--output=FILE", "-o", "Flush output in FILE (stdout by default)") do |value|
          self.output_file = value
        end

        opt.separator "\nRecognized format options:"
        add_io_format_options(opt)

        # CSV output options
        opt.separator "\nCSV options:"
        add_csv_output_options(opt)

        # JSON output options
        opt.separator "\nJSON options:"
        add_json_output_options(opt)
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
              when :csv
                ds.to_csv(io, csv_options)
              when :json
                ds.to_json(io, json_options)
              when :ruby
                ds.to_ruby(io, ruby_options)
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