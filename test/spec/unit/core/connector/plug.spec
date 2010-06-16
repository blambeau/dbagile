require File.expand_path('../../../../spec_helper', __FILE__)
describe "DbAgile::Core::Connector#plug" do
  
  let(:connector){ ::DbAgile::Core::Connector.new }
  
  subject{ connector.main_delegate.delegate_chain.collect{|c| c.class} }
  
  context "when call on main chain" do
    before{ connector.plug(Fixtures::Capitalize) }
    it{ should == [Fixtures::Capitalize] }
  end
  
  context "when call on main chain with two plugins" do
    before{ connector.plug(Fixtures::Capitalize, Fixtures::SayHello) }
    it{ should == [Fixtures::Capitalize, Fixtures::SayHello] }
  end
  
  context "when call on main chain with two plugins through two plugs" do
    before{ 
      connector.plug(Fixtures::SayHello) 
      connector.plug(Fixtures::Capitalize) 
    }
    it{ should == [Fixtures::Capitalize, Fixtures::SayHello] }
  end
  
end