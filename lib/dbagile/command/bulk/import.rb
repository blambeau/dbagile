module DbAgile
  class Command
    module Bulk
      #
      # Import a table from (csv, json, yaml, ruby)
      #
      # Usage: dba #{command_name} [OPTIONS] TABLE [FILE]
      #
      class Import < Command
        include Bulk::Commons
        include ::DbAgile::Tools::Tuple
        Command::build_me(self, __FILE__)
      
        # Input file to use
        attr_accessor :input_file
      
        # Drop table?
        attr_accessor :drop_table
      
        # Create table?
        attr_accessor :create_table
      
        # Truncate table?
        attr_accessor :truncate_table
            
        # Update tuple when key already exists?
        attr_accessor :update_on_existing
            
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
          opt.on("--update", "-u", "Update tuple instead of insert when key already exists") do |value|
            self.update_on_existing = true
          end
          opt.on('--dry-run', "Trace SQL statements on STDOUT only, do nothing on the database") do |value|
            self.conn_options[:trace_sql] = true
            self.conn_options[:trace_only] = true
          end

          opt.separator "\nRecognized format options:"
          add_input_format_options(opt)
          add_typesafe_options(opt)
        
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
            block.call(environment.input_buffer)
          end
        end
      
        # Yields the block with each emitted tuple 
        def with_emitter(&block)
          with_io{|io|
            options = io_options[self.format]
            options[:type_system] = self.type_system if self.type_system
            options[:input_file] = self.input_file
            case self.format
              when :csv
                DbAgile::IO::CSV::from_csv(io, options, &block)
              when :json
                DbAgile::IO::JSON::from_json(io, options, &block)
              when :yaml
                DbAgile::IO::YAML::from_yaml(io, options, &block)
              when :ruby
                DbAgile::IO::Ruby::from_ruby(io, options, &block)
            end
          }
        end
      
        # Executes the command
        def execute_command
          with_current_connection(conn_options) do |connection|
                  
            # Make the job now
            connection.transaction do |t|
              first = true
              with_emitter do |tuple|
                make_the_job(t, tuple, first)
                first = false
              end
            end
          
          end
        end
      
        def find_key(t, tuple)
          t.keys(self.dataset).find{|key|
            key.all?{|k| tuple.has_key?(k)}
          }
        end
      
        # Makes the insert job
        def make_the_job(t, tuple, first = true)
          handle_schema_modification(t, tuple) if first
          if self.update_on_existing 
            
            # find a candidate key
            key = find_key(t, tuple)
            if key.nil?
              raise DbAgile::CandidateKeyNotFoundError, "Unable to find a candidate key for UPDATE"
            end

            # Make insert or update according to key
            key_value = tuple_project(tuple, key)
            if t.exists?(self.dataset, key_value)
              t.update(self.dataset, tuple, key_value)
            else
              t.insert(self.dataset, tuple)
            end
          else
            t.insert(self.dataset, tuple)
          end
        end
      
        # Handles the schema modifications
        def handle_schema_modification(t, tuple)
          # Handle table creation/deletion/truncation
          if drop_table
            t.drop_table(self.dataset) if t.has_table?(self.dataset)
          end
          if create_table
            heading = tuple_heading(tuple)
            heading = check_tuple_heading(heading, environment)
            t.create_table(self.dataset, heading)
          end
          if truncate_table
            t.delete(self.dataset, {})
          end
        end
      
      end # class Import
    end # module Bulk
  end # class Command
end # module DbAgile