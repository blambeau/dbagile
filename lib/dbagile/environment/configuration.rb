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
        @config_file_path ||= File.join(ENV['HOME'], '.dbagile')
      end
      
      #
      # Sets the path to the .dbagile file
      #
      def config_file_path=(path)
        @config_file_path = path
      end
      
      # 
      # Ensures that config_file is loaded and returns the ConfigFile instance. 
      # If create is set to true, a default configuration file is created when 
      # file does not exists. Otherwise raises a NoConfigFileError.
      #
      # ATTENTION: the ConfigFile instance is kept in cache. It will not be 
      # synchronized with modifications of the underlying file made by another 
      # process/thread.
      #
      # @param [Boolean] create create default file if not existing?
      # @raise NoConfigFileError if create is false and file do not exists
      # @raise IOError if something goes wrong when reading/writing the file
      # @raise CorruptedConfigFileError if something goes wrong when parsing the file
      # @return [ConfigFile] configuration file instance
      #
      def config_file(create = true)
        @config_file ||= load_config_file(create, config_file_path)
      end
      
      # 
      # Yields the block with the ConfigFile instance loaded using config_file.
      #
      # As this method is a wrapper on config_file, it shares the specification
      # about parameters and exceptions.
      #
      # @return [...] result of the block execution
      # @raise ArgumentError if no block is provided
      #
      def with_config_file(create = true)
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
      # @raise UnknownConfigError if the configuration cannot be found.
      # @return block execution result
      #
      def with_config(name)
        raise ArgumentError, "Missing block" unless block_given?
        config = config_file.config(name)
        raise UnknownConfigError if config.nil?
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
      def with_current_config
        raise ArgumentError, "Missing block" unless block_given?
        config = config_file.current_config
        raise NoDefaultConfigError if config.nil?
        yield(config)
      end
      
      # Protected section starts here ###################################################
      protected
      
      #
      # Loads a configuration file and returns a ConfigFile instance. 
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
          ::DbAgile::Core::ConfigFile.new(file)
        rescue Exception => ex
          raise CorruptedConfigFileError, "Corrupted config file #{file}", ex.backtrace
        end
      end

    end # module Configuration
  end # class Environment
end # module DbAgile