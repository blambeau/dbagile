require File.expand_path('../../../../spec_helper', __FILE__)
describe "DbAgile::Core::Connector#connect" do
  
  let(:connector){ ::DbAgile::Core::Connector.new }

  context "when called on an empty connector" do
    specify{ 
      conn = connector.connect(Fixtures::SayHello)
      conn.should be_kind_of(DbAgile::Core::Connector)
      conn.main_delegate.delegate_chain.collect{|c| c.class}.should == [Fixtures::SayHello] 
    }
  end
  
end