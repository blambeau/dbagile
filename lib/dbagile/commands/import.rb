require 'dbagile/commands/io_commons'
module DbAgile
  module Commands
    #
    # Imports the content of a table in different formats
    #
    class Import < ::DbAgile::Commands::Command
      include ::DbAgile::Commands::IOCommons
      
      # Input file to use
      attr_accessor :input_file
      
      # Connection options
      attr_accessor :conn_options
      
      # Drop table?
      attr_accessor :drop_table
      
      # Create table?
      attr_accessor :create_table
      
      # Truncate table?
      attr_accessor :truncate_table
      
      # Creates a command instance
      def initialize
        super
        install_default_configuration
        @conn_options = {}
      end
      
      # Returns the command banner
      def banner
        "usage: dba import [OPTIONS] TABLE [FILE]"
      end

      # Short help
      def short_help
        "Imports contents of a table from ruby/csv/json"
      end
      
      # Contribute to options
      def add_options(opt)
        # Main output options
        opt.separator "\nInput options:"
        opt.on("--input=FILE", "-i", "Read input from FILE (stdin by default)") do |value|
          self.input_file = value
        end

        opt.separator "\nSQL options:"
        opt.on("--create-table", "-c", "Create table before inserting values") do |value|
          self.drop_table = true
          self.create_table = true
          self.truncate_table = false
        end
        opt.on("--drop-table", "-d", "Drop table before inserting values") do |value|
          self.drop_table = true
          self.create_table = true
          self.truncate_table = false
        end
        opt.on("--truncate", "-t", "Truncate table before inserting values") do |value|
          self.truncate_table = true
        end
        opt.on('--trace-sql', "Trace SQL statements on STDOUT (but executes them)") do |value|
          self.conn_options[:trace_sql] = true
        end
        opt.on('--dry-run', "Trace SQL statements on STDOUT only, do nothing on the database") do |value|
          self.conn_options[:trace_sql] = true
          self.conn_options[:trace_only] = true
        end

        opt.separator "\nRecognized format options:"
        add_io_format_options(opt)

        # CSV output options
        opt.separator "\nCSV options:"
        add_csv_input_options(opt)
      end
      
      # Normalizes the pending arguments
      def normalize_pending_arguments(arguments)
        case arguments.size
          when 1
            self.dataset = arguments.shift.strip.to_sym
          when 2
            exit("Ambigous input file options", true) if self.input_file
            self.dataset = arguments.shift.strip.to_sym
            self.input_file = arguments.shift.strip
          else
            exit(nil, true)
        end
      end
      
      # Yields the block with the IO object to use for input
      def with_io(&block)
        if self.input_file
          File.open(self.input_file, "r", &block)
        else
          block.call(STDIN)
        end
      end
      
      # Yields the block with each emitted tuple 
      def with_emitter(&block)
        with_io{|io|
          case self.format
            when :csv
              DbAgile::IO::CSV::from_csv(io, csv_options, &block)
            when :json
            when :ruby
          end
        }
      end
      
      # Executes the command
      def execute_command
        # load the configuration file
        config_file = DbAgile::load_user_config_file(DbAgile::user_config_file, true)
        config = has_config!(config_file)
        
        # Make the job now
        begin
          config.connect(nil, conn_options).transaction do |t|
            first = true
            with_emitter do |tuple|
              make_the_job(t, tuple, first)
              first = false
            end
          end
        rescue Exception => ex
          puts ex.message
          puts ex.backtrace.join("\n")
          exit(ex.message, false)
        end
      end
      
      # Makes the insert job
      def make_the_job(t, tuple, first = true)
        handle_schema_modification(t, tuple) if first
        t.insert(self.dataset, tuple)
      end
      
      # Handles the schema modifications
      def handle_schema_modification(t, tuple)
        # Handle table creation/deletion/truncation
        if drop_table
          t.direct_sql("DROP TABLE #{self.dataset}") if t.has_table?(self.dataset)
        end
        if create_table
          heading = ::DbAgile::Adapter::Tools::tuple_heading(tuple)
          t.create_table(self.dataset, heading)
        end
        if truncate_table
          t.delete(self.dataset, {})
        end
      end
      
    end # class List
  end # module Commands
end # module DbAgile