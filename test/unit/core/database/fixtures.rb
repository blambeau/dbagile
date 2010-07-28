require File.expand_path('../../../fixtures', __FILE__)
require File.expand_path('../../schema/fixtures', __FILE__)
module DbAgile
  module Fixtures
    module Core
      module Database
        include Fixtures::Utils
      
        # Returns a database file
        def database_file(name_or_file)
          find_file(name_or_file, __FILE__, ".dba")
        end
        
        # Yields block for each database file
        def each_database_file(&block)
          each_file(__FILE__, ".dba", &block)
        end
        
        # Returns a Schema instance for a given name
        def database(name_or_file)
          src = ::File.read(database_file(name_or_file))
          Kernel::eval(src)
        end

        extend(Database)
      end # module Database
    end # module Core
  end # module Fixtures
end # module DbAgile