module DbAgile
  module Core
    class Schema
      module YAMLMethods
      
        # Loads a schema from a YAML string
        def yaml_load(str)
          logical, physical = nil, nil
          YAML::each_document(str){|doc|
            unless doc.kind_of?(Hash) and doc.size == 1
              raise DbAgile::Error, "Invalid schema YAML file" 
            end
            case doc.keys[0]
              when 'logical'
                logical = doc
              when 'physical'
                physical = doc
              else
                raise DbAgile::Error, "Invalid schema YAML file"
            end
          }
          physical = {} unless physical
          raise DbAgile::Error, "Invalid schema YAML file" if logical.nil? or physical.nil?
          Schema.new(logical, physical)
        end
      
        # Loads a schema from a YAML file
        def yaml_file_load(path_or_io)
          case path_or_io
            when String
              File.open(path_or_io, 'r'){|io| yaml_load(io) }
            when IO, File
              yaml_load(path_or_io)
            else 
              raise ArgumentError, "Unable to load schema from #{file}"
          end
        end
      
      end # module YAMLMethods
    end # class Schema
  end # module Core
end # module DbAgile