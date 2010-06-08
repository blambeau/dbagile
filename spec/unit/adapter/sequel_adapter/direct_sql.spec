require File.expand_path('../../../../spec_helper', __FILE__)
describe "::FlexiDB::Adapter.direct_sql" do
  
  let(:adapter){ Fixtures::sqlite_testdb_sequel_adapter }
  
  describe "When called with a SELECT query" do
    subject{ adapter.direct_sql("SELECT * FROM flexidb") }
    it{ should be_kind_of(Enumerable) }
  end
  
  describe "When called with a DELETE query" do
    subject{ adapter.direct_sql("DELETE FROM flexidb") }
    specify{ 
      adapter.dataset(:flexidb).count.should == 0
    }
  end
  
end