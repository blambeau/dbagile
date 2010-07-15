module DbAgile
  module Commands
    #
    # Adds a configuration in ~/.dbagile with a (name, uri)
    #
    class Add < ::DbAgile::Commands::Command
      
      # Name of the configuration to add
      attr_accessor :name
      
      # Database URI of the configuration to add
      attr_accessor :uri
      
      # Makes it the current configuration
      attr_accessor :current
      
      # Creates a command instance
      def initialize
        super
        @current = true
      end
      
      # Returns the command banner
      def banner
        "usage: dba add NAME URI"
      end

      # Short help
      def short_help
        "Add a new database configuration"
      end
      
      # Contribute to options
      def add_options(opt)
        opt.separator nil
        opt.separator "Options:"
        opt.on("--no-current", "Don't make the new config the current one") do
          self.current = false
        end
      end
      
      # Normalizes the pending arguments
      def normalize_pending_arguments(arguments)
        exit(nil, true) unless arguments.size == 2
        self.name = arguments.shift.to_sym
        self.uri = arguments.shift
      end
      
      # Executes the command
      def execute_command
        # load the configuration file
        config_file = DbAgile::load_user_config_file(DbAgile::user_config_file, true)
        
        # Create the configuration and adds it
        config = ::DbAgile::Core::Configuration.new(self.name)
        config.uri(self.uri)
        config_file << config
        
        # Makes it the current one if requested
        config_file.current_config_name = config.name if self.current
        
        # Flush the configuration file
        config_file.flush!
        
        # List available databases now
        DbAgile::Commands::List.new.run(nil, [])
      end
      
    end # class List
  end # module Commands
end # module DbAgile