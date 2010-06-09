require File.expand_path('../../../spec_helper', __FILE__)
describe "::FlexiDB::Plugin#insert" do
  
  let(:adapter){ ::FlexiDB::MemoryAdapter.new }
  before{ adapter.create_table(:table_name, :id => Integer, :name => String)}
  
  describe "when call on last brick" do
    let(:brick){ ::FlexiDB::Plugin.new(adapter) }
    specify {
      brick.insert(:table_name, :id => 1, :name => "flexidb")
      adapter.dataset(:table_name).to_a.should == [{:id => 1, :name => "flexidb"}]
    }
  end
  
  describe "when call on non-last brick" do
    let(:brick){ ::FlexiDB::Plugin.new(::FlexiDB::Plugin.new(adapter)) }
    specify {
      brick.insert(:table_name, :id => 1, :name => "flexidb")
      adapter.dataset(:table_name).to_a.should == [{:id => 1, :name => "flexidb"}]
    }
  end

end