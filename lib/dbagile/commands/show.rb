module DbAgile
  module Commands
    #
    # Shows the content of a table
    #
    class Show < ::DbAgile::Commands::Command
      
      # Dataset whose contents must be shown
      attr_accessor :dataset
      
      # Creates a command instance
      def initialize
        super
      end
      
      # Returns the command banner
      def banner
        "usage: dba show DATASET"
      end

      # Short help
      def short_help
        "Display content of a table/view/query"
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
      end
      
      # Normalizes the pending arguments
      def normalize_pending_arguments(arguments)
        exit(nil, true) unless arguments.size == 1
        self.dataset = arguments.shift.strip
        unless /select|SELECT/ =~ self.dataset
          self.dataset = self.dataset.to_sym
        end
      end
      
      # Executes the command
      def execute_command
        # load the configuration file
        config_file = DbAgile::load_user_config_file(DbAgile::user_config_file, true)
        config = has_config!(config_file)
        
        # Make the job now
        begin
          ds = config.connect.dataset(self.dataset)
          info DbAgile::Utils::PrettyTable::print(ds, "")
        rescue Exception => ex
          exit(ex.message, false)
        end
      end
      
    end # class List
  end # module Commands
end # module DbAgile