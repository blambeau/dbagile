require 'dbagile/core/repository/yaml_methods'
module DbAgile
  module Core
    class Repository
      include Enumerable
      extend Repository::YAMLClassMethods
      include Repository::YAMLInstanceMethods
    
      # Index file name
      REPOSITORY_INDEX_FILE_NAME = "dbagile.idx"
    
      # Path to the root path of the repository
      attr_reader :root_path
    
      # Repository version
      attr_accessor :version
      private :version=
    
      # Databases as an array of Database instances
      attr_reader :databases
    
      # Current database (its name, i.e. a Symbol)
      attr_accessor :current_db_name
    
      #############################################################################################
      ### Initialization and parsing
      #############################################################################################
    
      # Creates a repository instance
      def initialize(root_path, version = DbAgile::VERSION)
        DbAgile::Robustness::valid_rw_directory!(root_path)
        DbAgile::Robustness::valid_rw_file!(File.join(root_path, REPOSITORY_INDEX_FILE_NAME))
        @root_path = root_path
        @version = version
        @databases = []
      end
      
      #############################################################################################
      ### File management
      #############################################################################################
      
      # Returns a friendly path to be printed to user
      def friendly_path
        DbAgile::FileSystemTools::friendly_path!(root_path)
      end
      
      # Returns the path to the index file
      def index_file
        File.join(root_path, REPOSITORY_INDEX_FILE_NAME)
      end
    
      # Returns a file resolver Proc instance
      def file_resolver
        @file_resolver ||= lambda{|f| 
          if f[0, 1] == '/'
            f
          else
            ::File.join(self.root_path, f) 
          end
        }
      end
      
      # Resolves a file which could be relative to repository root path
      def resolve_file(f)
        file_resolve.call(f)
      end
    
      #############################################################################################
      ### About databases
      #############################################################################################
    
      # Checks if at least one database exists
      def empty?
        databases.empty?
      end
    
      # Checks if a database exists
      def has_database?(name)
        !database(name).nil?
      end
    
      # Checks if a name/database is the current one
      def current?(name_or_db)
        case name_or_db
          when Symbol
            return nil unless has_database?(name_or_db)
            self.current_db_name == name_or_db
          when Core::Database
            self.current_db_name == name_or_db.name
          else
            raise ArgumentError, "Symbol or Database expected, #{name_or_db.inspect} found."
        end
      end
    
      # Yields the block with each database in turn
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
    
      # Returns the current database
      def current_database
        database(current_db_name)
      end
    
      #############################################################################################
      ### Updates
      #############################################################################################
    
      # Adds a database instance
      def <<(db)
        db.file_resolver = file_resolver
        self.databases << db
      end
    
      # Removes a database from this repository
      def remove(db)
        db = self.database(db)
        db.nil? ? nil : databases.delete(db)
      end
    
      #############################################################################################
      ### Input/output
      #############################################################################################
      
      #
      # Loads a repository from a root path
      #
      # @param [String] root_path path to a repository folder
      # @raise IOError if required repository files do not exists or access is denied 
      # @raise DbAgile::CorruptedRepositoryError if anything goes wrong
      #
      def self.load(root_path)
        # some checks first
        DbAgile::Robustness::valid_rw_directory!(root_path)
        index_file = File.join(root_path, REPOSITORY_INDEX_FILE_NAME)
        msg = "Not a dbagile repository, missing or access denied on #{index_file}"
        DbAgile::Robustness::valid_rw_file!(index_file, msg)
        
        # loading
        begin
          from_yaml_file(index_file, root_path) 
        rescue StandardError => ex
          msg = "Repository corruped: #{ex.message}"
          raise DbAgile::CorruptedRepositoryError, msg, ex.backtrace
        end
      end
      
      # 
      # Creates a fresh new repository somewhere
      #
      # @param [String] root_path path to an unexisting repository folder
      # @return [Repository] the created repository instance
      # @raise IOError is the repository already exists or cannot be created.
      #
      def self.create!(root_path)
        DbAgile::Robustness::unexisting_directory!(root_path)
        index_file = File.join(root_path, REPOSITORY_INDEX_FILE_NAME)
        FileUtils.mkdir_p(root_path)
        FileUtils.touch(index_file)
        repo = Repository.new(root_path, DbAgile::VERSION)
        repo.save!
      end
    
      #
      # Saves the repository
      #
      # @return [Repository] the repository itself
      # @raise IOError if something goes wrong when saving the repository
      #
      def save!
        DbAgile::Robustness::valid_rw_file!(self.index_file)
        flush(self.index_file)
        self
      end
    
      # 
      # Flushes the repository into a given file or IO
      #
      # This method is not robust to dir/file errors and should be protected
      # upstream.
      #
      def flush(output_file)
        if output_file.kind_of?(::IO)
          output_file << to_yaml
        else
          ::File.open(output_file, 'w'){|io| flush(io)}
        end
        self
      end
    
      private :flush
      private_class_method :from_yaml_file, :from_yaml
    end # class Repository
  end # module Core
end # module DbAgile