require File.expand_path('../../spec_helper', __FILE__)
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
  
  # Returns a path to the .dbagile-like repository in fixtures
  def dbagile_config_path
    File.join(root_path, "dbagile_config")
  end
  module_function :dbagile_config_path
  
  # Returns a path to the .dbagile-like repository in fixtures
  def dbagile_history_path
    File.join(root_path, "dbagile_history")
  end
  module_function :dbagile_history_path
  
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
  
  # Returns adapters under test
  def adapters_under_test
    [sqlite_testdb_sequel_adapter]
  end
  module_function :adapters_under_test
  
end # module Fixture
