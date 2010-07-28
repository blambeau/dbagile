module DbAgile
  module Core
    class Repository
      include Enumerable
    
      # Path to the actual file
      attr_reader :file
    
      # Databases as an array of Database instances
      attr_reader :databases
    
      # Current database (its name, i.e. a Symbol)
      attr_accessor :current_db_name
    
      #############################################################################################
      ### Initialization and parsing
      #############################################################################################
    
      # Creates a repository instance, by parsing content of file.
      def initialize(file)
        @file = file
        @databases = []
      end
    
      #############################################################################################
      ### Queries
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
        db.file_resolver = lambda{|f| 
          if f[0, 1] == '/'
            f
          else
            ::File.expand_path("../#{f}", self.file) 
          end
        }
        self.databases << db
      end
    
      # Removes a database from this repository
      def remove(db)
        db = self.database(db)
        db.nil? ? nil : databases.delete(db)
      end
    
      #############################################################################################
      ### YAML input/output
      #############################################################################################
    
      # Dumps the schema to YAML
      def to_yaml(opts = {})
        YAML::quick_emit(self, opts){|out|
          dbmap = {}
          databases.each{|db| dbmap[db.name.to_s] = db}
          out.map("tag:yaml.org,2002:map") do |map|
            map.add('databases', dbmap)
            map.add('current', self.current_db_name.to_s)
          end
        }
      end
      
      # Loads from a YAML file
      def self.from_yaml(str, file = nil)
        # Load the hash
        hash = YAML::load(str)
        
        # create the repository instance
        repo = Repository.new(file)
        
        # load databases
        hash['databases'].each_pair{|dbname, dbconfig|
          db = Core::Database.new(dbname.to_s.to_sym)
          db.file_resolver = repo
          dbconfig.each_pair{|key, value|
            db.send(:"#{key}=", value)
          }
          repo << db
        }
        
        # Set current database
        current = hash['current'].to_s.strip
        unless current.empty?
          repo.current_db_name = current.to_sym
        end
        
        repo
      end
      
      # Loading from a YAML file
      def self.from_yaml_file(file)
        if File::exists?(file) and File::file?(file)
          from_yaml(File.read(file), file)
        else
          Repository.new(file)
        end
      rescue StandardError => ex
        msg = "Repository index #{file} seems corruped: #{ex.message}"
        raise DbAgile::CorruptedRepositoryError, msg, ex.backtrace
      end
        
      # Flushes the repository into a given file
      def flush(output_file)
        if output_file.kind_of?(::IO)
          output_file << to_yaml
        else
          ::File.open(output_file, 'w'){|io| flush(io)}
        end
        self
      end
    
      # Flushes the repository into the source file
      def flush!
        flush(self.file)
      end
    
    end # class Repository
  end # module Core
end # module DbAgile