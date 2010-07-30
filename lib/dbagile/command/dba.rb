module DbAgile
  class Command
    #
    # Agile SQL databases and tools for database administrators
    #
    # Usage: dba [--version] [--help] [--list]
    #        dba help [--complete] <subcommand>
    #        dba [--config=FILE] [--use=DB] <subcommand> [OPTIONS] [ARGS]
    #
    # DbAgile aims at supporting database administrators and developers of database
    # oriented application. Read more about it on http://blambeau.github.com/dbagile.
    #
    class Dba < Command
      Command::build_me(self, __FILE__)
      
      # Configuration file
      attr_accessor :repository_path
      
      # Database to use
      attr_accessor :use_database
      
      # Show backtrace?
      attr_accessor :show_backtrace
      
      # Continue after my options
      attr_accessor :stop_after_options

      # Contribute to options
      def add_options(opt)
        opt.separator nil
        opt.separator "Options:"
        opt.on("--config=FILE", 
               "Use a specific repository (current is #{repository.friendly_path})") do |value|
          self.repository_path = value
        end
        opt.on("--use=DB", 
               "Use a specific database") do |value|
          self.use_database = value
        end
        opt.on_tail("--help", "Show list of available subcommands") do
          show_long_help
          self.stop_after_options = true
        end
        opt.on_tail("--[no-]backtrace", "Print a backtrace when an error occurs") do |value|
          self.show_backtrace = value
        end
        opt.on_tail("--version", "Show version") do
          say("dba" << " " << DbAgile::VERSION << " (c) 2010, Bernard Lambeau")
          self.stop_after_options = true
        end
      end

      # Returns commands by category
      def commands_by_categ
        return @commands_by_categ if @commands_by_categ
        @commands_by_categ = Hash.new{|h,k| h[k] = []}
        Command.subclasses.each do |subclass|
          next if subclass == Dba
          name     = Command::command_name_of(subclass)
          command  = Command::command_for(name, environment)
          category = command.category
          raise "Unknown command category #{category}" unless DbAgile::Command::CATEGORIES.include?(category)
          @commands_by_categ[category] << command
        end
        @commands_by_categ
      end

      # Show command help for a specific category
      def show_commands_help(category)
        commands_by_categ[category].each do |command|
          display options.summary_indent + command.command_name.ljust(30) + command.summary.to_s
        end
      end

      # Shows the short help
      def show_short_help
        display banner
        display options.summarize
        display "\n"
      end
      alias :show_help :show_short_help
      
      # Shows the long help
      def show_long_help
        show_short_help
        DbAgile::Command::CATEGORIES.each{|categ|
          display DbAgile::Command::CATEGORY_NAMES[categ]
          show_commands_help(categ)
          display ""
        }
      end
      
      # Runs the command
      def unsecure_run(requester_file, argv)
        # My own options
        my_args = []
        while argv.first =~ /^--/
          my_args << argv.shift
        end
        options.parse!(my_args)
        
        # Prepare the environment
        if self.repository_path
          environment.repository_path = self.repository_path
        end
        unless self.show_backtrace.nil?
          environment.show_backtrace = self.show_backtrace
        end
        if self.use_database
          environment.repository.current_db_name = self.use_database.to_sym
        end
        
        # Invoke sub command
        unless stop_after_options
          invoke_subcommand(requester_file, argv) 
        end
      rescue Exception => ex
        environment.on_error(self, ex)
        environment
      end
      
      # Invokes the subcommand
      def invoke_subcommand(requester_file, argv)
        # Command execution
        if argv.size >= 1
          command = has_command!(argv.shift, environment)
          command.run(requester_file, argv)
        else
          show_long_help
        end
      end

    end # class DbA
  end # class Command
end # module DbAgile