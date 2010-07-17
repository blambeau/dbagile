module DbAgile
  class Command
    class DbA < Command

      # Returns command's category
      def category
        :dba
      end

      # Returns the command banner
      def banner
        "usage: dba [--version] [--help]\n       dba help <subcommand>\n       dba <subcommand> [OPTIONS] [ARGS]"
      end

      # Shows the help
      def show_help
        commands_by_categ = Hash.new{|h,k| h[k] = []}
        Command.subclasses.each do |subclass|
          next if subclass == DbA
          name    = Command::command_name_of(subclass)
          command = Command::command_for(name, environment)
          commands_by_categ[command.category] << command
        end
        
        display banner
        display "\n"
        display "Main commands:"
        commands_by_categ[:dba].each do |command|
          display "  #{align(command.command_name,10)} #{command.short_help}" 
        end
        display ""
        display "Configuration management:"
        commands_by_categ[:configuration].each do |command|
          display "  #{align(command.command_name,10)} #{command.short_help}" 
        end
        display ""
        display "Import/Export management:"
        commands_by_categ[:io].each do |command|
          display "  #{align(command.command_name,10)} #{command.short_help}" 
        end
        display ""
      end
      
      # Runs the command
      def run(requester_file, argv)
        environment.load_history
        
        # Basic features
        case argv[0]
          when "--version"
            say("dba" << " " << DbAgile::VERSION << " (c) 2010, Bernard Lambeau")
            return
          when "--help", /^--/
            show_help
            return
        end
        
        # Save command in history 
        unless ['replay', 'history'].include?(argv[0])
          environment.push_in_history(argv) 
        end
        
        # Command execution
        if argv.size >= 1
          command = has_command!(argv.shift, environment)
          command.run(requester_file, argv)
        else
          show_help
        end
      rescue Exception => ex
        environment.on_error(self, ex)
        environment
      ensure
        environment.save_history if environment.manage_history?
      end

    end # class DbA
  end # class Command
end # module DbAgile