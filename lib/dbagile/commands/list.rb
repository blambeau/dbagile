module DbAgile
  module Commands
    #
    # List available database handler listed in ~/.dbagile file
    #
    class List < ::DbAgile::Commands::Command
      
      # Verbose ?
      attr_accessor :verbose
      
      # Creates a command instance
      def initialize
        super
        @verbose = false
      end
      
      # Returns the command banner
      def banner
        "usage: dba list"
      end

      # Short help
      def short_help
        "List available databases (found in ~/.dbagile)"
      end
      
      # Shows the help
      def show_help
        info banner
        info ""
        info short_help
        info ""
      end

      # Contribute to options
      def add_options(opt)
        opt.on("--verbose", "-v", "Displays full content of ~/.dbagile file") do |value|
          self.verbose = true
        end
      end
      
      # Normalizes the pending arguments
      def normalize_pending_arguments(arguments)
        unless arguments.empty?
          show_help
          exit(nil, false)
        end
      end
      
      # Checks the command and exit if any option problem is found
      def check_command
        true
      end
      
      # Executes the command
      def execute_command
        if verbose
          file = user_config_file
          if File.exists?(file)
            info File.read(file)
          end 
        else
          load_user_config_file
          unless DbAgile::CONFIGURATIONS.empty?
            info("Available databases are:")
            DbAgile::CONFIGURATIONS.each_pair do |name, config|
              info("  #{align(name,15)} #{config.uri}")
            end
          else
            info("No database configuration found. Checks ~/.dbagile")
          end
        end
      end
      
    end # class List
  end # module Commands
end # module DbAgile