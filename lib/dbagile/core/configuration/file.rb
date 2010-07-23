module DbAgile
  module Core
    class Configuration
      #
      # Implements user configuration files
      #
      class File
        include Enumerable
      
        # Path to the actual file
        attr_reader :file
      
        # Configurations as an array of Configuration instances
        attr_reader :configurations
      
        # Current configuration (its name, i.e. a Symbol)
        attr_accessor :current_config_name
      
        #############################################################################################
        ### Initialization and parsing
        #############################################################################################
      
        # Creates a config file instance, by parsing content of file.
        def initialize(file)
          @file = file
          @configurations = []
          if ::File.exists?(file)
            raise "File expected, folder found (#{file})" unless ::File.file?(file)
            raise "Unable to read #{file}" unless ::File.readable?(file)
            parse_file(file)
          end
        end
      
        # Parses contents of the file
        def parse_file(file)
          parse(::File.read(file))
        end
      
        # Parses a configuration source
        def parse(source)
          Configuration::DSL.new(self).instance_eval(source)
        end
      
        #############################################################################################
        ### Queries
        #############################################################################################
      
        # Checks if at least one configuration exists
        def empty?
          configurations.empty?
        end
      
        # Checks if a configuration exists
        def has_config?(name)
          !config(name).nil?
        end
      
        # Checks if a name/configuration is the current one
        def current?(name_or_config)
          case name_or_config
            when Symbol
              return nil unless has_config?(name_or_config)
              self.current_config_name == name_or_config
            when Configuration
              self.current_config_name == name_or_config.name
            else
              raise ArgumentError, "Symbol or Configuration expected, #{name_or_config.inspect} found."
          end
        end
      
        # Yields the block with each configuration in turn
        def each(*args, &block)
          configurations.each(*args, &block)
        end
      
        # Returns a configuration by match. Returns nil if no such configuration
        def config(match)
          return match if match.kind_of?(::DbAgile::Core::Configuration)
          configurations.find{|c| 
            case match
              when Symbol
                c.name == match
              when String
                c.uri == match
              when Regexp
                match =~ c.uri
            end
          }
        end
      
        # Returns the current configuration
        def current_config
          config(current_config_name)
        end
      
        #############################################################################################
        ### Updates
        #############################################################################################
      
        # Adds a configuration instance
        def <<(config)
          config.file_resolver = lambda{|f| File.expand_path("../#{f}", self.file) }
          self.configurations << config
        end
      
        # Removes a configuration from this config file
        def remove(config)
          config = self.config(config)
          config.nil? ? nil : configurations.delete(config)
        end
      
        #############################################################################################
        ### Inspection and output
        #############################################################################################
      
        # Flushes the configuration into a given file
        def flush(output_file)
          if output_file.kind_of?(::IO)
            output_file << self.inspect
          else
            ::File.open(output_file, 'w'){|io| flush(io)}
          end
          self
        end
      
        # Flushes the configuration into the source file
        def flush!
          flush(self.file)
        end
      
        # Inspects this configuration file
        def inspect(prefix = "")
          buffer = ""
          configurations.each{|cfg| buffer << cfg.inspect(prefix) << "\n"}
          buffer << "current_config " << current_config_name.inspect unless current_config_name.nil?
          buffer
        end
      
        private :parse_file, :parse
      end # class File
    end # class Configuration
  end # module Core
end # module DbAgile