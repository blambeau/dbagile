module DbAgile
  module Core
    class Schema
      module YAMLMethods
      
        # Loads a schema from a YAML string
        def yaml_load(str, builder = DbAgile::Core::Schema::Builder.new)
          YAML::each_document(str){|doc|
            builder._natural(doc)
          }
          builder._dump
        end
      
        # Loads a schema from a YAML file
        def yaml_file_load(path_or_io, builder = DbAgile::Core::Schema::Builder.new)
          case path_or_io
            when String
              File.open(path_or_io, 'r'){|io| yaml_load(io, builder) }
            when IO, File
              yaml_load(path_or_io, builder)
            else 
              raise ArgumentError, "Unable to load schema from #{file}"
          end
        end
        
      end # module YAMLMethods
    end # class Schema
  end # module Core
end # module DbAgile