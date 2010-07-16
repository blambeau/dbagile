require File.expand_path('../../../../spec_helper', __FILE__)
describe "::DbAgile::Plugin::AgileTable#insert" do
  
  let(:db){
    DbAgile::config(:test){ (plug AgileTable) }.connect("memory://test.db")
  }
  
  describe "When called on an existing table with already existing columns" do
    before{ db.transaction{|t| t.create_table(:example, :id => Integer) } }
    subject{ 
      db.transaction{|t| t.insert(:example, :id => 1) }
    }
    specify{ 
      subject.should == {:id => 1}
      db.column_names(:example).should == [:id]
      db.dataset(:example).to_a.should == [{:id => 1}]
    }
  end
  
  describe "When called on an existing table with non existing columns" do
    before{ db.transaction{|t| t.create_table(:example, :id => Integer) } }
    subject{ 
      db.transaction{|t| t.insert(:example, :name => "blambeau") } 
    }
    specify{ 
      subject.should == {:name => "blambeau"}
      db.column_names(:example, true).should == [:id, :name]
    }
  end
  
  describe "When called on an existing table with a mix" do
    before{ db.transaction{|t| t.create_table(:example, :id => Integer) } }
    subject{ 
      db.transaction{|t| t.insert(:example, :id => 1, :name => "blambeau") } 
    }
    specify{ 
      db.has_table?(:example).should be_true
      subject.should == {:id => 1, :name => "blambeau"}
      db.column_names(:example, true).should == [:id, :name]
    }
  end
  
  describe "When called on a non existing table with create option" do
    let(:options){ {:create_table => true} }
    subject{ 
      db.transaction{|t| t.insert(:example, :id => 1, :name => "blambeau") } 
    }
    specify{ 
      subject.should == {:id => 1, :name => "blambeau"}
      db.has_table?(:example).should be_true
      db.column_names(:example, true).should == [:id, :name]
    }
  end
  
end