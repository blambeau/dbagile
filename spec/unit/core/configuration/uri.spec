require File.expand_path('../../../../spec_helper', __FILE__)
describe "DbAgile::Core::Configuration#uri" do
  
  context "when called with a configuration block" do
    let(:config){ 
      DbAgile::Core::Configuration.new{ uri "memory://test.db" }
    }
    subject{ config.uri }
    specify{
      subject.should == "memory://test.db"
      config.uri.should == "memory://test.db"
    }
  end
  
end
  
