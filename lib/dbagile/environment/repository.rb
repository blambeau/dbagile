module DbAgile
  class Environment
    module Repository
      
      #
      # Returns path to the repository
      #
      def repository_path
        @repository_path
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
      #
      # ATTENTION: the Repository instance is kept in cache. It will not be 
      # synchronized with modifications of the underlying files made by another 
      # process/thread.
      #
      # @raise IOError if the repository does not exists or something goes wrong
      #        with repository dir/files
      # @raise CorruptedRepositoryError if something goes wrong when parsing the 
      #        repository index file
      # @return [Repository] repository instance
      # @see DbAgile::Core::Repository::load
      #
      def repository
        @repository ||= DbAgile::Core::Repository::load(repository_path)
      end
      
      #
      # Yields the block with each database in turn
      #
      # As this method is a wrapper on repository, it shares the specification
      # about exceptions.
      #
      # @raise ArgumentError if no block is provided
      #
      def each_database(&block)
        raise ArgumentError, "Missing block" unless block_given?
        repository.each(&block)
      end
      
      # 
      # Yields the block with the Repository instance (loaded using repository)
      #
      # As this method is a wrapper on repository, it shares the specification
      # about exceptions.
      #
      # @return [...] result of the block execution
      # @raise ArgumentError if no block is provided
      #
      def with_repository
        raise ArgumentError, "Missing block" unless block_given?
        yield(repository)
      end
      
      #
      # Yields the block with a Database instance found by name in the 
      # repository 
      #
      # As this method relies on repository, it shares its exception contract.
      #
      # @raise ArgumentError if no block is provided
      # @raise NoSuchDatabaseError if the database cannot be found.
      # @return block execution result
      #
      def with_database(name)
        raise ArgumentError, "Missing block" unless block_given?
        db = repository.database(name)
        raise NoSuchDatabaseError if db.nil?
        yield(db)
      end
      
      # 
      # Yields the block with the Database instance for the current one 
      # in repository.
      # 
      # As this method relies on repository, it shares its exception contract.
      #
      # @raise ArgumentError if no block is provided
      # @raise NoDefaultDatabaseError if the database cannot be found.
      # @return block execution result
      #
      def with_current_database
        raise ArgumentError, "Missing block" unless block_given?
        db = repository.current_database
        raise NoDefaultDatabaseError if db.nil?
        yield(db)
      end
      
      #
      # Yields the block with a connection on a given database; diconnect after that.
      #
      # As this method relies on repository, it shares its exception contract.
      #
      # @raise ArgumentError if no block is provided
      # @raise NoSuchDatabaseError if the database cannot be found.
      # @return block execution result
      #
      def with_connection(db, conn_options = {}, &block)
        case db
          when Symbol
            db = repository.database(db)
          when DbAgile::Core::Database
          else
            raise ArgumentError, "Invalid database name #{db}"
        end
        raise NoSuchDatabaseError if db.nil?
        db.with_connection(&block)
      end
      
      # 
      # Yields the block with a connection on the current database.
      #
      # Same contract as with_connection, expect for parameters.
      #
      # @raise NoDefaultDatabaseError if the database cannot be found.
      #
      def with_current_connection(conn_options = {}, &block)
        with_current_database{|db|
          with_connection(db, conn_options, &block)
        }
      end
      
    end # module Repository
  end # class Environment
end # module DbAgile