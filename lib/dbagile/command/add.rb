module DbAgile
  class Command
    #
    # Adds a configuration in ~/.dbagile with a (name, uri)
    #
    class Add < Command
      
      # Name of the configuration to add
      attr_accessor :config_name
      
      # Database URI of the configuration to add
      attr_accessor :uri
      
      # Makes it the current configuration
      attr_accessor :current
      
      # Returns the command banner
      def banner
        "usage: dba add NAME URI"
      end
      
      # Returns command's category
      def category
        :configuration
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
        self.config_name, self.uri = valid_argument_list!(arguments, Symbol, String)
      end
      
      # Checks command 
      def check_command
        valid_configuration_name!(self.config_name)
        valid_database_uri!(self.uri)
      end
      
      #
      # Executes the command.
      #
      # @return [DbAgile::Core::Configuration] the created configuration
      #
      def execute_command
        config = nil
        with_config_file do |config_file|
        
          if config_file.has_config?(self.config_name)
            raise ConfigNameConflictError, "Configuration #{self.config_name} already exists"
          else
            # Create the configuration and adds it
            config = ::DbAgile::Core::Configuration.new(self.config_name)
            config.uri(self.uri)
            config_file << config
        
            # Makes it the current one if requested
            config_file.current_config_name = config.name if self.current
        
            # Flush the configuration file
            config_file.flush!
          end
          
        end

        # List available databases now
        DbAgile::command(environment){|env, api| api.list %w{}}
        
        # Returns created configuration
        config
      end
      
    end # class List
  end # class Command
end # module DbAgile