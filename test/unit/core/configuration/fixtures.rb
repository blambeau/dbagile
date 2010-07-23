require File.expand_path('../../../fixtures', __FILE__)
require File.expand_path('../../schema/fixtures', __FILE__)
module DbAgile
  module Fixtures
    module Core
      module Configuration
        include Fixtures::Utils
      
        # Returns a config file
        def config_file(name_or_file)
          find_file(name_or_file, __FILE__, ".dba")
        end
        
        # Yields block for each config file
        def each_config_file(&block)
          each_file(__FILE__, ".dba", &block)
        end
        
        # Returns a Schema instance for a given name
        def config(name_or_file)
          src = ::File.read(config_file(name_or_file))
          Kernel::eval(src)
        end

        extend(Configuration)
      end # module Configuration
    end # module Core
  end # module Fixtures
end # module DbAgile