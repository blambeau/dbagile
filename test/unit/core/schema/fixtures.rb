require File.expand_path('../../../fixtures', __FILE__)
module DbAgile
  module Fixtures
    module Core
      module Schema
      
        # Returns a schema file
        def schema_file(name_or_file)
          if name_or_file.kind_of?(Symbol)
            name_or_file = schema_file("#{name_or_file}.yaml") 
          end
          unless name_or_file[0, 1] == '/'
            name_or_file = File.expand_path("../fixtures/#{name_or_file}", __FILE__) 
          end
          name_or_file
        end
        
        # Yields block for each config file
        def each_schema_file(&block)
          Dir[File.expand_path("../fixtures/*.yaml", __FILE__)].each(&block)
        end
        
        # Returns a Schema instance for a given name
        def schema(name_or_file)
          DbAgile::Core::Schema::yaml_file_load(schema_file(name_or_file))
        end
      
        extend(Schema)
      end # module Configuration
    end # module Core
  end # module Fixtures
end # module DbAgile