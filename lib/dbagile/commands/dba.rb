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
        # info "  help       Show help of a specific command"
        # info "  use        Sets the database handler to use for next commands"
        # info "  list       List available databases (found in ~/.dbagile)"
        # info "  show       Show the content of a table/view/query"
        # info "  cvs        Flush table/view/query content in a CSV file"
        ::DbAgile::Commands::Command.subclasses.each do |subclass|
          info "  #{align(command_name_of(subclass),10)} #{subclass.new.short_help}" unless subclass == DbA
        end
        info ""
      end
      
      # Runs the command
      def run(requester_file, argv)
        @requester_file = requester_file
        
        # Basic features
        case argv[0]
          when "--help"
            show_help
            exit(nil, false)
          when "--version"
            exit("dba" << " " << DbAgile::VERSION << " (c) 2010, Bernard Lambeau", false)
          when /^--/
            show_help
            exit(nil, false)
        end
        
        # Command execution
        command_name = argv.shift
        command = command_for(command_name)
        if command.nil?
          show_help
          exit(nil, false)
        else
          command.run(requester_file, argv)
        end
      end

    end # class DbA
  end # module Commands
end # module DbAgile