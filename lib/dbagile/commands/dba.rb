module DbAgile
  module Commands
    class DbA < ::DbAgile::Commands::Command
      
      # Returns the command banner
      def banner
        "usage: dba [--version] [--help]\n       dba COMMAND [OPTIONS] [ARGS]"
      end

      # Shows the help
      def show_help
        info banner
        info ""
        info "Available DbAgile commands are:"
        info "  help       Show help of a specific command"
        info "  use        Sets the database handler to use for next commands"
        info "  list       List available databases (found in ~/.dbagile)"
        info "  show       Show the content of a table/view/query"
        info "  cvs        Flush table/view/query content in a CSV file"
        info ""
      end

      # Contribute to options
      def add_options(opt)
        # No argument, shows at tail.  This will print an options summary.
        # Try it and see!
        opt.on_tail("-h", "--help", "Show this message") do
          show_help
          exit(nil, false)
        end

        # Another typical switch to print the version.
        opt.on_tail("--version", "Show version") do
          exit(opt.program_name << " " << DbAgile::VERSION << " (c) 2010, Bernard Lambeau", false)
        end
      end
      
      # Normalizes the pending arguments
      def normalize_pending_arguments(arguments)
        show_help
        exit(nil, false)
      end
      
      # Checks the command and exit if any option problem is found
      def check_command
      end
      
      # Executes the command
      def execute_command
      end
      
      
    end # class DbA
  end # module Commands
end # module DbAgile