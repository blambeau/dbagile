module DbAgile
  module Core
    class Repository
      
      module YAMLInstanceMethods

        # Dumps the repository to YAML
        def to_yaml(opts = {})
          YAML::quick_emit(self, opts){|out|
            dbmap = DbAgile::Tools::OrderedHash.new
            databases.each{|db| dbmap[db.name.to_s] = db}
            out.map("tag:yaml.org,2002:map") do |map|
              map.add('version', self.version)
              map.add('databases', dbmap)
              map.add('current', self.current_db_name.to_s)
            end
          }
        end
      
      end # module YAMLInstanceMethods

      module YAMLClassMethods

        #
        # Loads a repository from a YAML file and returns a Core::Repository instance.
        #
        # This method is not robust at all and re-raises any error that occurs. It
        # should be protected upstream.
        #
        # @param [String] file path to a repository index (exist, readable)
        # @param [String] root_path path of the repository itself (exist, readable)
        # @raise DbAgile::CorruptedRepositoryError if anything goes wrong.
        #
        def from_yaml_file(file, root_path)
          from_yaml(File.read(file), root_path)
        end
        
        #
        # Loads a repository from a YAML file and returns a Core::Repository instance.
        #
        # This method is not robust at all and re-raises any error that occurs. It
        # should be protected upstream.
        #
        # @param [String] str a YAML source
        # @param [String] root_path root path to set on the repository 
        #
        def from_yaml(str, root_path)
          # Load the hash
          hash = YAML::load(str)
        
          # Load the repository version
          version = hash['version'].to_s.strip
          if version.nil? or version.empty?
            raise "missing version number"
          end
        
          # create the repository instance
          repo = Repository.new(root_path, version)
        
          # load databases
          hash['databases'].each_pair{|dbname, dbconfig|
            db = Core::Database.new(dbname.to_s.to_sym)
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
      
      end # module YAMLClassMethods
      
    end # class Repository
  end # module Core
end # module DbAgile
