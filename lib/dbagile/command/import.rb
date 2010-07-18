require 'dbagile/command/io_commons'
module DbAgile
  class Command
    #
    # Imports the content of a table in different formats
    #
    class Import < Command
      include ::DbAgile::Command::IOCommons
      include ::DbAgile::Adapter::Tools
      
      # Input file to use
      attr_accessor :input_file
      
      # Drop table?
      attr_accessor :drop_table
      
      # Create table?
      attr_accessor :create_table
      
      # Truncate table?
      attr_accessor :truncate_table
            
      # Returns command's category
      def category
        :io
      end
      
      # Returns the command banner
      def banner
        "usage: dba import [OPTIONS] TABLE [FILE]"
      end

      # Short help
      def short_help
        "Import a table from (csv, json, yaml, ruby)"
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
        add_input_format_options(opt)

        # CSV output options
        opt.separator "\nCSV options:"
        add_csv_input_options(opt)
      end
      
      # Normalizes the pending arguments
      def normalize_pending_arguments(arguments)
        case arguments.size
          when 1
            self.dataset = valid_argument_list!(arguments, Symbol)
          when 2
            raise OptionParser::AmbiguousArgument, '--input-file=#{self.input_file}' if self.input_file
            self.dataset, self.input_file = valid_argument_list!(arguments, Symbol, String)
          else
            bad_argument_list!(arguments)
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
              DbAgile::IO::JSON::from_json(io, ruby_options, &block)
            when :yaml
              DbAgile::IO::YAML::from_yaml(io, ruby_options, &block)
            when :ruby
              DbAgile::IO::Ruby::from_ruby(io, ruby_options, &block)
          end
        }
      end
      
      # Executes the command
      def execute_command
        with_current_config do |config|
        
          # Make the job now
          config.connect(nil, conn_options).transaction do |t|
            first = true
            with_emitter do |tuple|
              make_the_job(t, tuple, first)
              first = false
            end
          end
          
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
          heading = tuple_heading(tuple)
          t.create_table(self.dataset, heading)
        end
        if truncate_table
          t.delete(self.dataset, {})
        end
      end
      
    end # class List
  end # class Command
end # module DbAgile