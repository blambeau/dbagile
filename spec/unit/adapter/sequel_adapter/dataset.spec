require File.expand_path('../../../../spec_helper', __FILE__)
describe "::FlexiDB::SequelAdapter.dataset" do
  
  let(:adapter){ Fixtures::sqlite_testdb_sequel_adapter }
  
  describe "When with SQL" do
    subject{ adapter.dataset("SELECT * FROM flexidb") }
    it{ should be_kind_of(Enumerable) }
    it{ should respond_to(:to_a) }
  end

end