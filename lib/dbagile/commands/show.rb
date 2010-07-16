module DbAgile
  module Commands
    #
    # Shows the content of a table
    #
    class Show < ::DbAgile::Commands::Command
      
      # Dataset whose contents must be shown
      attr_accessor :dataset
      
      # Makes pretty output?
      attr_accessor :pretty
      
      # Creates a command instance
      def initialize
        super
        @pretty = true
      end
      
      # Returns the command banner
      def banner
        "usage: dba show DATASET"
      end

      # Short help
      def short_help
        "Display content of a table/view/query"
      end
      
      # Contribute to options
      def add_options(opt)
        opt.separator nil
        opt.separator "Options:"
        opt.on("--[no-]pretty",
               "Make/Avoid pretty output (truncate string at terminal size and so on.)") do |value|
          self.pretty = value
        end
      end
      
      # Normalizes the pending arguments
      def normalize_pending_arguments(arguments)
        exit(nil, true) unless arguments.size == 1
        self.dataset = arguments.shift.strip
        unless /select|SELECT/ =~ self.dataset
          self.dataset = self.dataset.to_sym
        end
      end
      
      # Infer pretty options
      def infer_pretty_options
        return {} unless pretty
        begin
          gem 'highline', '>= 1.5.2'
          require 'highline'
          {:truncate_at => HighLine.new.output_cols-3, :append_with => '...'}
        rescue LoadError
          info("Console output is pretty with highline. Try 'gem install highline'")
          {}
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
          ds.to_text(buffer, infer_pretty_options)
        rescue Exception => ex
          exit(ex.message, false)
        end
      end
      
    end # class List
  end # module Commands
end # module DbAgile