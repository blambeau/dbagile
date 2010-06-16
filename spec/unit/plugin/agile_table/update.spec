require File.expand_path('../../../../spec_helper', __FILE__)
describe "::DbAgile::Plugin::AgileTable#update" do
  
  let(:adapter){ DbAgile::MemoryAdapter.new }
  let(:options){ Hash.new }
  let(:chain){ DbAgile::Utils::Chain[DbAgile::Plugin::AgileTable.new(options), adapter] }
  before{ 
    adapter.create_table(nil, :example, :id => Integer, :name => String) 
    adapter.insert(nil, :example, :id => 1, :name => "dbagile")
  }
  
  describe "When called on an existing table with already existing columns" do
    subject{ chain.update(nil, :example, {:id => 1}, {:name => "DbAgile"}) }
    specify{ 
      subject.should be_true
      adapter.column_names(:example, true).should == [:id, :name]
      adapter.dataset(:example).to_a.should == [{:id => 1, :name => "DbAgile"}]
    }
  end
  
  describe "When called on an existing table with non existing columns" do
    subject{ 
      chain.update(nil, :example, {:id => 1}, :hello => "world") 
    }
    specify{ 
      subject.should be_true
      adapter.column_names(:example, true).should == [:hello, :id, :name]
      adapter.dataset(:example).to_a.should == [{:id => 1, :name => "dbagile", :hello => "world"}]
    }
  end
  
  describe "When called on an existing table with a mix" do
    subject{ 
      chain.update(nil, :example, {:id => 1}, {:name => "DbAgile", :hello => "world"}) 
    }
    specify{ 
      subject.should be_true
      adapter.column_names(:example, true).should == [:hello, :id, :name]
      adapter.dataset(:example).to_a.should == [ {:id => 1, :name => "DbAgile", :hello => "world"} ]
    }
  end
    
end