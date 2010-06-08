require File.expand_path('../../../../spec_helper', __FILE__)
describe "::FlexiDB::Chain::Brick#adapter" do
  
  let(:fake_adapter){ ::FlexiDB::FakeAdapter.new }
  
  describe "when call on last brick" do
    let(:brick){ ::FlexiDB::Chain::Brick.new(fake_adapter) }
    subject{ brick.adapter }
    it { should == fake_adapter }
  end

  describe "when call on non-last delegate" do
    let(:brick){ ::FlexiDB::Chain::Brick.new(::FlexiDB::Chain::Brick.new(fake_adapter)) }
    subject{ brick.adapter }
    it { should == fake_adapter }
  end

end