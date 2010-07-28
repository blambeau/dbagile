require File.expand_path('../../../fixtures', __FILE__)
module DbAgile
  module Fixtures
    module Core
      module Repository
        include Fixtures::Utils
    
        def repository_path(name_or_file)
          find_file(name_or_file, __FILE__, ".yaml")
        end
      
        def each_repository_path(&block)
          each_file(__FILE__, ".yaml", &block)
        end
      
        # Returns a Schema instance for a given name
        def repository(name_or_file)
          DbAgile::Core::Repository::from_yaml_file(repository_path(name_or_file))
        end
      
        extend(Repository)
      end
    end # module Core
  end # module Fixtures
end # module DbAgile