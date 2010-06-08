require File.expand_path('../../../spec_helper', __FILE__)
describe "::FlexiDB::Database#insert" do
  
  let(:db){ Fixtures::sqlite_testdb }
  
  describe "When called on an unexisting table" do
    subject{ 
      db.insert(:people, {:id => 1, :name => "flexidb"})
    }
    it{
      should == {:id => 1, :name => "flexidb"} 
    }
  end

end