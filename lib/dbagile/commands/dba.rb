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
        Command.subclasses.each do |subclass|
          info "  #{align(Command.command_name_of(subclass),10)} #{subclass.new.short_help}" unless subclass == DbA
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
        if argv.size >= 1
          command = has_command!(argv.shift)
          command.run(requester_file, argv)
        else
          show_help
        end
      rescue ::DbAgile::Error => ex
        exit(ex.message, false)
      end

    end # class DbA
  end # module Commands
end # module DbAgile