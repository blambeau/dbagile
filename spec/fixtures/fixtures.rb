require 'fileutils'
require 'sequel'
module Fixtures
  
  TESTDB_CREATE_SQL = <<-EOF
    CREATE TABLE flexidb (
      version CHAR(10),
      schema  TEXT
    );
  EOF
  
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
  
  # Ensures that the sqlite test database is correctly installed
  def ensure_sqlite_testdb(force = false)
    return if File.exists?(sqlite_testdb_path) and not(force)
    FileUtils.rm_rf(sqlite_testdb_path)
    db = Sequel::connect(sqlite_testdb_uri)
    db << TESTDB_CREATE_SQL
    db.disconnect
  end
  module_function :ensure_sqlite_testdb
  
  # Returns a SequelAdapter on the test database
  def sqlite_testdb_sequel_adapter
    ensure_sqlite_testdb(true)
    FlexiDB::SequelAdapter.new(sqlite_testdb_uri)
  end
  module_function :sqlite_testdb_sequel_adapter
  
end # module Fixture
