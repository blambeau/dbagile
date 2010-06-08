require File.expand_path('../../../../spec_helper', __FILE__)
describe "::FlexiDB::Chain::Brick#insert" do
  
  let(:fake_adapter){ ::FlexiDB::FakeAdapter.new }
  
  describe "when call on last brick" do
    let(:brick){ ::FlexiDB::Chain::Brick.new(fake_adapter) }
    specify {
      brick.insert(:table_name, :id => 1, :name => "flexidb")
      fake_adapter.calls.should == [
        [:insert, [:table_name, {:id => 1, :name => "flexidb"}]]
      ]
    }
  end
  
  describe "when call on non-last brick" do
    let(:brick){ ::FlexiDB::Chain::Brick.new(::FlexiDB::Chain::Brick.new(fake_adapter)) }
    specify {
      brick.insert(:table_name, :id => 1, :name => "flexidb")
      fake_adapter.calls.should == [
        [:insert, [:table_name, {:id => 1, :name => "flexidb"}]]
      ]
    }
  end

end