require File.expand_path('../../../../spec_helper', __FILE__)
describe "::FlexiDB::Adapter.has_table" do
  
  let(:adapter){ Fixtures::sqlite_testdb_sequel_adapter }
  
  describe "When called on existing table" do
    before{ adapter.ensure_table(:example, :id => Integer) }
    subject{ adapter.insert(:example, :id => 12) }
    specify{ 
      subject.should == {:id => 12} 
    }
  end
  
end