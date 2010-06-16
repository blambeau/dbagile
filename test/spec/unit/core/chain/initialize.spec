require File.expand_path('../../../../spec_helper', __FILE__)
describe "DbAgile::Core::Chain#initialize" do
  
  context "when called with no args" do
    let(:chain){ DbAgile::Core::Chain.new }
    specify{ chain.delegate_chain.should == [] }
  end
  
  context "when called one argument" do
    let(:chain){ DbAgile::Core::Chain.new("hello") }
    specify{ chain.delegate_chain.should == ["hello"] }
  end
  
  context "when called many arguments" do
    let(:chain){ DbAgile::Core::Chain.new("hello 1", "hello 2") }
    specify{ chain.delegate_chain.should == ["hello 1", "hello 2"] }
  end
  
end
