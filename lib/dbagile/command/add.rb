module DbAgile
  class Command
    #
    # Adds a configuration in ~/.dbagile with a (name, uri)
    #
    class Add < Command
      
      # Name of the configuration to add
      attr_accessor :name
      
      # Database URI of the configuration to add
      attr_accessor :uri
      
      # Makes it the current configuration
      attr_accessor :current
      
      # Returns the command banner
      def banner
        "usage: dba add NAME URI"
      end

      # Short help
      def short_help
        "Add a new database configuration"
      end
      
      # Sets the default options
      def set_default_options
        @current = true
      end
      
      # Contribute to options
      def add_options(opt)
        opt.separator nil
        opt.separator "Options:"
        opt.on("--[no-]current", "Set as current configuration when created (see use)") do |value|
          self.current = false
        end
      end
      
      # Normalizes the pending arguments
      def normalize_pending_arguments(arguments)
        self.name, self.uri = valid_argument_list!(arguments, Symbol, String)
      end
      
      # Checks command 
      def check_command
        valid_configuration_name!(self.name)
        valid_database_uri!(self.uri)
      end
      
      # Executes the command
      def execute_command
        with_config_file do |config_file|
        
          # Create the configuration and adds it
          config = ::DbAgile::Core::Configuration.new(self.name)
          config.uri(self.uri)
          config_file << config
        
          # Makes it the current one if requested
          config_file.current_config_name = config.name if self.current
        
          # Flush the configuration file
          config_file.flush!
        
        end
        # List available databases now
        DbAgile::Command::List.new.run(nil, [])
      end
      
    end # class List
  end # class Command
end # module DbAgile