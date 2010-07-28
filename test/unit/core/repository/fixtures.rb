require File.expand_path('../../../fixtures', __FILE__)
module DbAgile
  module Fixtures
    module Core
      module Repository
        include Fixtures::Utils
    
        def config_file_path(name_or_file)
          find_file(name_or_file, __FILE__, ".cfg")
        end
      
        def each_config_file_path(&block)
          each_file(__FILE__, ".cfg", &block)
        end
      
        # Returns a Schema instance for a given name
        def config_file(name_or_file)
          DbAgile::Core::Repository.new(config_file_path(name_or_file))
        end
      
        extend(Repository)
      end
    end # module Core
  end # module Fixtures
end # module DbAgile