require File.expand_path('../../../../spec_helper', __FILE__)
describe "::DbAgile::Plugin::AgileTable#update" do
  
  let(:db){
    DbAgile::config(:test){ 
      uri "sqlite://test.db"
      plug DbAgile::Plugin::AgileTable
    }.connect
  }
  
  before{ 
    db.transaction do |t|
      t.drop_table(:example) if t.has_table?(:example)
      t.create_table(:example, :id => Integer, :name => String) 
      t.insert(:example, :id => 1, :name => "dbagile")
    end
  }
  
  describe "When called on an existing table with already existing columns" do
    subject{ 
      db.transaction{|t| t.update(:example, {:name => "DbAgile"}, {:id => 1}) }
    }
    specify{ 
      subject.should be_true
      db.column_names(:example, true).should == [:id, :name]
      db.dataset(:example).to_a.should == [{:id => 1, :name => "DbAgile"}]
    }
  end
  
  describe "When called on an existing table with non existing columns" do
    subject{ 
      db.transaction{|t| t.update(:example, {:hello => "world"}, {:id => 1}) }
    }
    specify{ 
      subject.should be_true
      db.column_names(:example, true).should == [:hello, :id, :name]
      db.dataset(:example).to_a.should == [{:id => 1, :name => "dbagile", :hello => "world"}]
    }
  end
  
  describe "When called on an existing table with a mix" do
    subject{ 
      db.transaction{|t| t.update(:example, {:name => "DbAgile", :hello => "world"}, {:id => 1}) }
    }
    specify{ 
      subject.should be_true
      db.column_names(:example, true).should == [:hello, :id, :name]
      db.dataset(:example).to_a.should == [ {:id => 1, :name => "DbAgile", :hello => "world"} ]
    }
  end
    
end