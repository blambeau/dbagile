module DbAgile
  class Command
    module Bulk
      #
      # Export a table/view/query to (csv, json, yaml, ruby, xml)
      #
      # Usage: dba #{command_name} [OPTIONS] DATASET [FILE]
      #
      # This command helps exporting data in a SQL database to common transfer 
      # formats.
      #
      class Export < Command
        include Bulk::Commons
        Command::build_me(self, __FILE__)
      
        # Output file to use
        attr_accessor :output_file
      
        # Contribute to options
        def add_options(opt)
          # Main output options
          opt.separator "\nOutput options:"
          opt.on("--output=FILE", "-o", "Flush output in FILE (stdout by default)") do |value|
            self.output_file = value
          end

          opt.separator "\nRelational options:"
          add_select_options(opt)

          opt.separator "\nRecognized format options:"
          add_output_format_options(opt)
          add_typesafe_options(opt)

          # CSV output options
          opt.separator "\nCSV options:"
          add_csv_output_options(opt)

          # CSV output options
          opt.separator "\nTEXT options:"
          add_text_output_options(opt)

          # HTML output options
          opt.separator "\nHTML options:"
          add_html_output_options(opt)

          # JSON output options
          opt.separator "\nJSON options:"
          add_json_output_options(opt)
        end
      
        # Normalizes the pending arguments
        def normalize_pending_arguments(arguments)
          case arguments.size
            when 1
              self.dataset = valid_argument_list!(arguments, String)
            when 2
              raise OptionParser::AmbiguousArgument, '--output-file=#{self.output_file}' if self.output_file
              self.dataset, self.output_file = valid_argument_list!(arguments, String, String)
            else
              bad_argument_list!(arguments)
          end
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
            block.call(environment.output_buffer)
          end
        end
      
        # Executes the command
        def execute_command
          with_current_connection do |connection|
            # Prepare the dataset
            ds = connection.dataset(self.dataset)
            if self.select
              ds = ds.select(*self.select)
            elsif self.allbut
              ds = ds.allbut(*self.allbut)
            end
        
            # Export it
            with_io{|io| 
              method = "to_#{self.format}".to_sym
              io = environment.output_buffer
              options =  io_options[self.format]
              options[:type_system] = self.type_system if self.type_system
              ds.send(method, io, options)
            }
          end
        end
      
      end # class Export
    end # module Bulk
  end # class Command
end # module DbAgile