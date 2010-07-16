module DbAgile
  class Command
    class DbA < Command
      
      # Returns the command banner
      def banner
        "usage: dba [--version] [--help]\n       dba help <subcommand>\n       dba <subcommand> [OPTIONS] [ARGS]"
      end

      # Shows the help
      def show_help
        display banner
        display "\n"
        display "Available DbAgile commands are:"
        Command.subclasses.each do |subclass|
          display "  #{align(Command.command_name_of(subclass),10)} #{subclass.new.short_help}" unless subclass == DbA
        end
        display ""
      end
      
      # Runs the command
      def run(requester_file, argv)
        @requester_file = requester_file
        
        # Basic features
        case argv[0]
          when "--version"
            say("dba" << " " << DbAgile::VERSION << " (c) 2010, Bernard Lambeau")
            return
          when "--help", /^--/
            show_help
            return
        end
        
        # Command execution
        if argv.size >= 1
          command = has_command!(argv.shift)
          command.run(requester_file, argv)
        else
          show_help
        end
      rescue Exception => ex
        environment.on_error(self, ex)
        environment
      end

    end # class DbA
  end # class Command
end # module DbAgile