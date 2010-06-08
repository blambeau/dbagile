require File.expand_path('../../../../spec_helper', __FILE__)
describe "::FlexiDB::Adapter.has_column" do
  
  let(:adapter){ Fixtures::sqlite_testdb_sequel_adapter }
  
  describe "When called on non existing table" do
    subject{ adapter.has_column?(:no_such_table, :no_such_column) }
    it{ should be_false }
  end
  
  describe "When called on an existing table but no such column" do
    subject{ adapter.has_column?(:flexidb, :no_such_column) }
    it{ should be_false }
  end
  
  describe "When called on an existing table and existing column" do
    subject{ adapter.has_column?(:flexidb, :version) }
    it{ should be_true }
  end
  
end