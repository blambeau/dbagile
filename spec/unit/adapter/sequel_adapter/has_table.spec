require File.expand_path('../../../../spec_helper', __FILE__)
describe "::FlexiDB::Adapter.has_table" do
  
  let(:adapter){ Fixtures::sqlite_testdb_sequel_adapter }
  
  describe "When called on non existing table" do
    subject{ adapter.has_table?(:no_such_table) }
    it{ should be_false }
  end
  
  describe "When called on existing table" do
    subject{ adapter.has_table?(:flexidb) }
    it{ should be_true }
  end
  
end