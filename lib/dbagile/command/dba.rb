module DbAgile
  class Command
    class DbA < Command
      
      # Command categories
      CATEGORIES = [:dba, :configuration, :io, :restful, :sql, :schema]
      
      # Names of the categories
      CATEGORY_NAMES = {
        :dba           => "Main commands:",
        :configuration => "Configuration management:",
        :io            => "Import/Export management:",
        :sql           => "Queries:",
        :schema        => "Database schema:",
        :restful       => "Database and the web"
      }

      # Configuration file
      attr_accessor :config_file_path
      
      # Database configuration to use
      attr_accessor :use_config
      
      # Continue after my options
      attr_accessor :stop_after_options

      # Returns command's category
      def category
        :dba
      end
      
      # Returns the command banner
      def banner
        "Usage: dba [--version] [--help]\n"\
        "       dba help <subcommand>\n"\
        "       dba [--config=FILE] [--use=DB] <subcommand> [OPTIONS] [ARGS]"
      end

      # Contribute to options
      def add_options(opt)
        opt.on("--config=FILE", 
               "Use a specific configuration file (defaults to ~/.dbagile)") do |value|
          self.config_file_path = value
        end
        opt.on("--use=DB", 
               "Use a specific database configuration") do |value|
          self.use_config = value
        end
        opt.on_tail("--help", "--help", "Show this message") do
          show_help
          self.stop_after_options = true
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
          next if subclass == DbA
          name     = Command::command_name_of(subclass)
          command  = Command::command_for(name, environment)
          category = command.category
          raise "Unknown command category #{category}" unless CATEGORIES.include?(category)
          @commands_by_categ[category] << command
        end
        @commands_by_categ
      end

      # Show command help for a specific category
      def show_commands_help(category)
        commands_by_categ[category].each do |command|
          display options.summary_indent + align(command.command_name,10) + command.short_help
        end
      end

      # Shows the help
      def show_help
        display banner
        display "\n"
        display "Options:"
        display options.summarize
        display "\n"
        
        CATEGORIES.each{|categ|
          display CATEGORY_NAMES[categ]
          show_commands_help(categ)
          display ""
        }
      end
      
      # Runs the command
      def unsecure_run(requester_file, argv)
        environment.load_history
        
        # My own options
        my_args = []
        while argv.first =~ /^--/
          my_args << argv.shift
        end
        options.parse!(my_args)
        
        # Prepare the environment
        if self.config_file_path
          environment.config_file_path = self.config_file_path
        end
        if self.use_config
          environment.config_file.current_config_name = self.use_config.to_sym
        end
        
        # Invoke sub command
        unless stop_after_options
          invoke_subcommand(requester_file, argv) 
        end
      rescue Exception => ex
        environment.on_error(self, ex)
        environment
      ensure
        environment.save_history if environment.manage_history?
      end
      
      # Invokes the subcommand
      def invoke_subcommand(requester_file, argv)
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
      end

    end # class DbA
  end # class Command
end # module DbAgile