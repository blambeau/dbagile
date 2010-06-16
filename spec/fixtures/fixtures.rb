require 'fileutils'
require 'sequel'
module Fixtures
  
  # Returns root path
  def root_path
    File.expand_path(File.dirname(__FILE__))
  end
  module_function :root_path
  
  # Returns sqlite testdb uri
  def sqlite_testdb_path
    File.join(root_path,"test.db")
  end
  module_function :sqlite_testdb_path
  
  # Returns sqlite testdb uri
  def sqlite_testdb_uri
    "sqlite://#{sqlite_testdb_path}"
  end
  module_function :sqlite_testdb_uri
  
  # Installs the default db on a given adapter
  def install_default_db(adapter)
    adapter.create_table(nil, :dbagile, {:id => Integer, :version => String, :schema => String})
  end
  module_function :install_default_db
  
  # Returns a Memory adapter on the test database
  def memory_testdb_adapter
    adapter = ::DbAgile::MemoryAdapter.new
    install_default_db(adapter)
    adapter
  end
  module_function :memory_testdb_adapter
  
  # Returns a SequelAdapter on the test database
  def sqlite_testdb_sequel_adapter
    FileUtils.rm_rf(sqlite_testdb_path)
    adapter = DbAgile::SequelAdapter.new(sqlite_testdb_uri)
    install_default_db(adapter)
    adapter
  end
  module_function :sqlite_testdb_sequel_adapter
  
  # Returns a Database instance on testdb sqlite adapter
  def sqlite_testdb
    DbAgile::Database.new(sqlite_testdb_sequel_adapter)
  end
  module_function :sqlite_testdb
  
  # Returns adapters under test
  def adapters_under_test
    [memory_testdb_adapter, sqlite_testdb_sequel_adapter]
  end
  module_function :adapters_under_test
  
  class SayHello
    def say_hello(who)
      who
    end
  end
  class Reverse
    def say_hello(who)
      delegate.say_hello(who.reverse)
    end
  end
  class Upcase
    def say_hello(who)
      delegate.say_hello(who.upcase)
    end
  end
  class Downcase
    def say_hello(who)
      delegate.say_hello(who.downcase)
    end
  end
  class Capitalize
    def initialize(method = :capitalize)
      @method = method
    end
    def say_hello(who)
      delegate.say_hello(who.send(@method))
    end
  end

end # module Fixture
