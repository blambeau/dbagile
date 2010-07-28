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
      def repository_path
        @repository_path ||= DbAgile::find_repository_path
      end
      
      #
      # Sets the path to the .dbagile file
      #
      def repository_path=(path)
        @repository = nil
        @repository_path = path
      end
      
      # 
      # Ensures that repository is loaded and returns the Repository instance. 
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
      def repository(create = true)
        @repository ||= load_repository(create, repository_path)
      end
      
      #
      # Yields the block with each configuration in turn
      #
      # As this method is a wrapper on repository, it shares the specification
      # about parameters and exceptions.
      #
      # @raise ArgumentError if no block is provided
      #
      def each_database(&block)
        raise ArgumentError, "Missing block" unless block_given?
        repository.each(&block)
      end
      
      # 
      # Yields the block with the Repository instance loaded using repository.
      #
      # As this method is a wrapper on repository, it shares the specification
      # about parameters and exceptions.
      #
      # @return [...] result of the block execution
      # @raise ArgumentError if no block is provided
      #
      def with_repository(create = true)
        raise ArgumentError, "Missing block" unless block_given?
        yield(repository(create))
      end
      
      #
      # Yields the block with a Configuration instance found by name in config 
      # file. 
      #
      # As this method relies on repository, it shares its exception contract.
      #
      # @raise ArgumentError if no block is provided
      # @raise NoSuchConfigError if the configuration cannot be found.
      # @return block execution result
      #
      def with_database(name)
        raise ArgumentError, "Missing block" unless block_given?
        config = repository.database(name)
        raise NoSuchConfigError if config.nil?
        yield(config)
      end
      
      # 
      # Yields the block with a Configuration instance for the current 
      # configuration found in condif file.
      # 
      # As this method relies on repository, it shares its exception contract.
      #
      # @raise ArgumentError if no block is provided
      # @raise NoDefaultConfigError if the configuration cannot be found.
      # @return block execution result
      #
      def with_current_database
        raise ArgumentError, "Missing block" unless block_given?
        config = repository.current_database
        raise NoDefaultConfigError if config.nil?
        yield(config)
      end
      
      #
      # Yields the block with a connection on a given config; diconnect after that.
      #
      # As this method relies on repository, it shares its exception contract.
      #
      # @raise ArgumentError if no block is provided
      # @raise NoSuchConfigError if the configuration cannot be found.
      # @return block execution result
      #
      def with_connection(config, conn_options = {}, &block)
        case config
          when Symbol
            config = repository.database(config)
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
      # Internal implementation of repository, almost same specification.
      #
      def load_repository(create, file)
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