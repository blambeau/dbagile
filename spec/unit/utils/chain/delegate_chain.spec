require File.expand_path('../../../../spec_helper', __FILE__)
describe "DbAgile::Utils::Chain#delegate_chain" do
  
  subject{ chain.delegate_chain }
  
  context "when called on an emtpy chain" do
    let(:chain){ DbAgile::Utils::Chain.new }
    it{ should == [] }
  end
  
  context "when called on a non emtpy chain" do
    let(:chain){ DbAgile::Utils::Chain.new("hello") }
    it{ should == ["hello"] }
  end
  
end
