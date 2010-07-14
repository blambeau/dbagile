module DbAgile
  module Core
    #
    # Implements user configuration files
    #
    class ConfigFile
      
      # Path to the actual file
      attr_reader :file
      
      # Configurations as an array of Configuration instances
      attr_reader :configurations
      
      # Current configuration (its name, i.e. a Symbol)
      attr_accessor :current_config
      
      #############################################################################################
      ### Class-level utils
      #############################################################################################
      
      # Domain-Specific-Language implementation of config files
      class DSL
        
        # Creates a DSL instance
        def initialize(config_file)
          @config_file = config_file
        end
        
        # Adds a configuration under a given name
        def config(name, &block)
          @config_file.configurations << Configuration.new(name, &block)
        end
        
        # Sets the current configuration
        def current_config(name)
          @config_file.current_config = name
        end
        
      end # class DSL
      
      # Returns path to the default user configuration file.
      def self.user_config_file
        File.join(ENV['HOME'], '.dbagile')
      end
      
      #############################################################################################
      ### Initialization and parsing
      #############################################################################################
      
      # Creates a config file instance, by parsing content of file.
      def initialize(file = ConfigFile.user_config_file)
        @file = file
        @configurations = []
        if File.exists?(file)
          raise "File expected, folder found (#{file})" unless File.file?(file)
          raise "Unable to read #{file}" unless File.readable?(file)
          parse_file(file)
        end
      end
      
      # Parses contents of the file
      def parse_file(file)
        parse(File.read(file))
      end
      
      # Parses a configuration source
      def parse(source)
        DSL.new(self).instance_eval(source)
      end
      
      #############################################################################################
      ### Queries
      #############################################################################################
      
      # Returns a configuration by name. Returns nil if no such configuration
      def config(name)
        configurations.find{|c| c.name == name}
      end
      
      # Checks if a configuration exists
      def has_config?(name)
        !config(name).nil?
      end
      
      #############################################################################################
      ### Inspection and output
      #############################################################################################
      
      # Flushes the configuration into a given file, the source file by default
      def flush(output_file = file)
        if output_file.kind_of?(IO)
          output_file << self.inspect
        else
          File.open(output_file, 'w'){|io| flush(io)}
        end
      end
      
      # Inspects this configuration file
      def inspect
        buffer = ""
        configurations.each{|cfg| buffer << cfg.inspect << "\n"}
        buffer << "current_config " << current_config.inspect
        buffer
      end
      
      private :parse_file, :parse
    end # class ConfigFile
  end # module Commands
end # module DbAgile