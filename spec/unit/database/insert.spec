require File.expand_path('../../../spec_helper', __FILE__)
describe "::FlexiDB::Database#insert" do
  
  let(:db){ Fixtures::sqlite_testdb }
  
  describe "When called on an unexisting table" do
    subject{ db.insert(:people, {:id => 1, :name => "flexidb"}) }
    specify{ 
      subject.should == {:id => 1, :name => "flexidb"}
      db.adapter.has_table?(:people).should be_true
      db[:people].count.should == 1 
    }
  end
  
  describe "When called on an existing table" do
    before{ db.insert(:people, {:id => 1, :name => "flexidb"}) }
    subject{ db.insert(:people, {:id => 2, :name => "blambeau"}) }
    specify{ 
      subject.should == {:id => 2, :name => "blambeau"}
      db.adapter.has_table?(:people).should be_true
      db[:people].count.should == 2
    }
  end
  
  describe "When called with additional attributes" do
    before{ db.insert(:people, {:id => 1, :name => "flexidb"}) }
    subject{ db.insert(:people, {:id => 2, :name => "blambeau", :encoding => "utf8"}) }
    specify{ 
      subject.should == {:id => 2, :name => "blambeau", :encoding => "utf8"}
      db.adapter.has_table?(:people).should be_true
      db[:people].count.should == 2
      db.adapter.column_names(:people, true).should == [:encoding, :id, :name]
    }
  end
  

end