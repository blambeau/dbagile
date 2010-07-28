module DbAgile
  class Environment
    # 
    # Environment's configuration contract.
    #
    module Configuration
      
      #
      # Returns path to .dbagile file
      #
      # Default implementation returns ~/.dbagile
      #
      def config_file_path
        @config_file_path ||= DbAgile::find_config_file_path
      end
      
      #
      # Sets the path to the .dbagile file
      #
      def config_file_path=(path)
        @config_file = nil
        @config_file_path = path
      end
      
      # 
      # Ensures that config_file is loaded and returns the Repository instance. 
      # If create is set to true, a default configuration file is created when 
      # file does not exists. Otherwise raises a NoConfigFileError.
      #
      # ATTENTION: the Repository instance is kept in cache. It will not be 
      # synchronized with modifications of the underlying file made by another 
      # process/thread.
      #
      # @param [Boolean] create create default file if not existing?
      # @raise NoConfigFileError if create is false and file do not exists
      # @raise IOError if something goes wrong when reading/writing the file
      # @raise CorruptedConfigFileError if something goes wrong when parsing the file
      # @return [Repository] configuration file instance
      #
      def config_file(create = true)
        @config_file ||= load_config_file(create, config_file_path)
      end
      
      #
      # Yields the block with each configuration in turn
      #
      # As this method is a wrapper on config_file, it shares the specification
      # about parameters and exceptions.
      #
      # @raise ArgumentError if no block is provided
      #
      def each_config(&block)
        raise ArgumentError, "Missing block" unless block_given?
        config_file.each(&block)
      end
      
      # 
      # Yields the block with the Repository instance loaded using config_file.
      #
      # As this method is a wrapper on config_file, it shares the specification
      # about parameters and exceptions.
      #
      # @return [...] result of the block execution
      # @raise ArgumentError if no block is provided
      #
      def with_repository(create = true)
        raise ArgumentError, "Missing block" unless block_given?
        yield(config_file(create))
      end
      
      #
      # Yields the block with a Configuration instance found by name in config 
      # file. 
      #
      # As this method relies on config_file, it shares its exception contract.
      #
      # @raise ArgumentError if no block is provided
      # @raise NoSuchConfigError if the configuration cannot be found.
      # @return block execution result
      #
      def with_config(name)
        raise ArgumentError, "Missing block" unless block_given?
        config = config_file.database(name)
        raise NoSuchConfigError if config.nil?
        yield(config)
      end
      
      # 
      # Yields the block with a Configuration instance for the current 
      # configuration found in condif file.
      # 
      # As this method relies on config_file, it shares its exception contract.
      #
      # @raise ArgumentError if no block is provided
      # @raise NoDefaultConfigError if the configuration cannot be found.
      # @return block execution result
      #
      def with_current_database
        raise ArgumentError, "Missing block" unless block_given?
        config = config_file.current_database
        raise NoDefaultConfigError if config.nil?
        yield(config)
      end
      
      #
      # Yields the block with a connection on a given config; diconnect after that.
      #
      # As this method relies on config_file, it shares its exception contract.
      #
      # @raise ArgumentError if no block is provided
      # @raise NoSuchConfigError if the configuration cannot be found.
      # @return block execution result
      #
      def with_connection(config, conn_options = {}, &block)
        case config
          when Symbol
            config = config_file.database(config)
          when DbAgile::Core::Database
          else
            raise ArgumentError, "Config should be a config name"
        end
        raise NoSuchConfigError if config.nil?
        config.with_connection(&block)
      end
      
      # 
      # Yields the block with a connection on the current config.
      #
      # Same contract as with_connection, expect for parameters.
      #
      # @raise NoDefaultConfigError if the configuration cannot be found.
      #
      def with_current_connection(conn_options = {}, &block)
        with_current_database{|config|
          with_connection(config, conn_options, &block)
        }
      end
      
      # Protected section starts here ###################################################
      protected
      
      #
      # Loads a configuration file and returns a Repository instance. 
      #
      # Internal implementation of config_file, almost same specification.
      #
      def load_config_file(create, file)
        # Creates file as required by spec
        if create and not(File.exists?(file))
          require 'fileutils'
          FileUtils.mkdir_p(File.dirname(file))
          FileUtils.touch(file)
        end
        
        # Make some checks
        unless File.exists?(file)
          raise NoConfigFileError, "No such config file #{file}" 
        end
        unless File.file?(file) and File.readable?(file)
          raise CorruptedConfigFileError, "Corrupted config file #{file}" 
        end

        # Loads it
        begin
          ::DbAgile::Core::Repository.new(file)
        rescue Exception => ex
          raise CorruptedConfigFileError, "Corrupted config file #{file}: #{ex.message}", ex.backtrace
        end
      end

    end # module Configuration
  end # class Environment
end # module DbAgile