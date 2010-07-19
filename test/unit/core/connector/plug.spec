require File.expand_path('../../../fixtures', __FILE__)
describe "DbAgile::Core::Connector#plug" do
  
  let(:connector){ ::DbAgile::Core::Connector.new }
  
  subject{ connector.main_delegate.delegate_chain.collect{|c| c.class} }
  
  context "when call on main chain" do
    before{ connector.plug(DbAgile::Fixtures::Capitalize) }
    it{ should == [DbAgile::Fixtures::Capitalize] }
  end
  
  context "when call on main chain with two plugins" do
    before{ connector.plug(DbAgile::Fixtures::Capitalize, DbAgile::Fixtures::SayHello) }
    it{ should == [DbAgile::Fixtures::Capitalize, DbAgile::Fixtures::SayHello] }
  end
  
  context "when call on main chain with two plugins through two plugs" do
    before{ 
      connector.plug(DbAgile::Fixtures::SayHello) 
      connector.plug(DbAgile::Fixtures::Capitalize) 
    }
    it{ should == [DbAgile::Fixtures::Capitalize, DbAgile::Fixtures::SayHello] }
  end
  
end