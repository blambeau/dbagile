require File.expand_path('../../../../spec_helper', __FILE__)
describe "::DbAgile::Plugin::AgileTable#update" do
  
  let(:adapter){ DbAgile::MemoryAdapter.new }
  before{ 
    adapter.create_table(:example, :id => Integer, :name => String) 
    adapter.insert(:example, :id => 1, :name => "dbagile")
  }
  
  describe "When called on an existing table with already existing columns" do
    subject{ DbAgile::Plugin::AgileTable.new(adapter).update(:example, {:id => 1}, {:name => "DbAgile"}) }
    specify{ 
      subject.should be_true
      adapter.column_names(:example, true).should == [:id, :name]
      adapter.dataset(:example).to_a.should == [{:id => 1, :name => "DbAgile"}]
    }
  end
  
  describe "When called on an existing table with non existing columns" do
    subject{ 
      DbAgile::Plugin::AgileTable.new(adapter).update(:example, {:id => 1}, :hello => "world") 
    }
    specify{ 
      subject.should be_true
      adapter.column_names(:example, true).should == [:hello, :id, :name]
      adapter.dataset(:example).to_a.should == [{:id => 1, :name => "dbagile", :hello => "world"}]
    }
  end
  
  describe "When called on an existing table with a mix" do
    subject{ 
      DbAgile::Plugin::AgileTable.new(adapter).update(:example, {:id => 1}, {:name => "DbAgile", :hello => "world"}) 
    }
    specify{ 
      subject.should be_true
      adapter.column_names(:example, true).should == [:hello, :id, :name]
      adapter.dataset(:example).to_a.should == [ {:id => 1, :name => "DbAgile", :hello => "world"} ]
    }
  end
    
end