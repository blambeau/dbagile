require File.expand_path('../../../fixtures', __FILE__)
module DbAgile
  module Fixtures
    module Core
      module Repository
        include Fixtures::Utils
    
        def repository_path(name_or_file)
          find_file(name_or_file, __FILE__)
        end
      
        def each_repository_path(&block)
          each_dir(__FILE__, &block)
        end
      
        # Returns a Schema instance for a given name
        def repository(name_or_file)
          DbAgile::Core::Repository::load(repository_path(name_or_file))
        end
      
        extend(Repository)
      end
    end # module Core
  end # module Fixtures
end # module DbAgile