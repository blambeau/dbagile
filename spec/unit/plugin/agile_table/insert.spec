require File.expand_path('../../../../spec_helper', __FILE__)
describe "::DbAgile::Plugin::AgileTable#insert" do
  
  let(:adapter){ DbAgile::MemoryAdapter.new }
  
  describe "When called on an existing table with already existing columns" do
    before{ adapter.create_table(:example, :id => Integer) }
    subject{ DbAgile::Plugin::AgileTable.new(adapter).insert(:example, :id => 1) }
    specify{ 
      subject.should == {:id => 1}
      adapter.column_names(:example).should == [:id]
      adapter.dataset(:example).to_a.should == [{:id => 1}]
    }
  end
  
  describe "When called on an existing table with non existing columns" do
    before{ adapter.create_table(:example, :id => Integer) }
    subject{ DbAgile::Plugin::AgileTable.new(adapter).insert(:example, :name => "blambeau") }
    specify{ 
      subject.should == {:name => "blambeau"}
      adapter.column_names(:example, true).should == [:id, :name]
    }
  end
  
  describe "When called on an existing table with a mix" do
    before{ adapter.create_table(:example, :id => Integer) }
    subject{ DbAgile::Plugin::AgileTable.new(adapter).insert(:example, :id => 1, :name => "blambeau") }
    specify{ 
      adapter.has_table?(:example).should be_true
      subject.should == {:id => 1, :name => "blambeau"}
      adapter.column_names(:example, true).should == [:id, :name]
    }
  end
  
  describe "When called on a non existing table with create option" do
    subject{ DbAgile::Plugin::AgileTable.new(adapter, :create_table => true).insert(:example, :id => 1, :name => "blambeau") }
    specify{ 
      subject.should == {:id => 1, :name => "blambeau"}
      adapter.has_table?(:example).should be_true
      adapter.column_names(:example, true).should == [:id, :name]
    }
  end
  
end