require 'fileutils'
require 'sequel'
module Fixtures
  
  # Returns root path
  def root_path
    File.expand_path(File.dirname(__FILE__))
  end
  module_function :root_path
  
  # Resolves a file inside fixtures subfolders
  def join_path(file)
    File.join(root_path, file)
  end
  module_function :join_path
  
  # Returns a path to the .dbagile-like config file in fixtures
  def dbagile_config_path
    File.join(root_path, "dbagile_config")
  end
  module_function :dbagile_config_path
  
  # Returns a path to the .dbagile-like config file in fixtures
  def dbagile_history_path
    File.join(root_path, "dbagile_history")
  end
  module_function :dbagile_history_path
  
  # Builds an environment for testing purposes
  def test_environment
    env = DbAgile::Environment.new
    env.config_file_path = dbagile_config_path
    env.history_file_path = dbagile_history_path
    env.output_buffer = []
    env
  end
  module_function :test_environment
  
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
    [sqlite_testdb_sequel_adapter]
  end
  module_function :adapters_under_test
  
  class SayHello
    def del_to_block
      yield
    end
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
