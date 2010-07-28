module DbAgile
  module Core
    class Repository
      include Enumerable
    
      # Path to the actual file
      attr_reader :file
    
      # Databases as an array of Database instances
      attr_reader :databases
    
      # Current configuration (its name, i.e. a Symbol)
      attr_accessor :current_db_name
    
      #############################################################################################
      ### Initialization and parsing
      #############################################################################################
    
      # Creates a config file instance, by parsing content of file.
      def initialize(file)
        @file = file
        @databases = []
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
        Core::IO::DSL.new(self).instance_eval(source)
      end
    
      #############################################################################################
      ### Queries
      #############################################################################################
    
      # Checks if at least one configuration exists
      def empty?
        databases.empty?
      end
    
      # Checks if a configuration exists
      def has_database?(name)
        !database(name).nil?
      end
    
      # Checks if a name/configuration is the current one
      def current?(name_or_config)
        case name_or_config
          when Symbol
            return nil unless has_database?(name_or_config)
            self.current_db_name == name_or_config
          when Core::Database
            self.current_db_name == name_or_config.name
          else
            raise ArgumentError, "Symbol or Database expected, #{name_or_config.inspect} found."
        end
      end
    
      # Yields the block with each configuration in turn
      def each(*args, &block)
        databases.each(*args, &block)
      end
    
      # Returns a database by match. Returns nil if no such database
      def database(match)
        return match if match.kind_of?(::DbAgile::Core::Database)
        databases.find{|c| 
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
        database(current_db_name)
      end
    
      #############################################################################################
      ### Updates
      #############################################################################################
    
      # Adds a configuration instance
      def <<(config)
        config.file_resolver = lambda{|f| 
          if f[0, 1] == '/'
            f
          else
            ::File.expand_path("../#{f}", self.file) 
          end
        }
        self.databases << config
      end
    
      # Removes a configuration from this config file
      def remove(config)
        config = self.database(config)
        config.nil? ? nil : databases.delete(config)
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
        databases.each{|cfg| buffer << cfg.inspect(prefix) << "\n"}
        buffer << "current_db " << current_db_name.inspect unless current_db_name.nil?
        buffer
      end
    
      private :parse_file, :parse
    end # class Repository
  end # module Core
end # module DbAgile