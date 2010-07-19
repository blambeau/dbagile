require File.expand_path('../../../fixtures', __FILE__)
describe "DbAgile::Core::Configuration#uri" do
  
  context "when called with a configuration block" do
    let(:config){ 
      DbAgile::Core::Configuration.new{ uri "sqlite://test.db" }
    }
    subject{ config.uri }
    specify{
      subject.should == "sqlite://test.db"
      config.uri.should == "sqlite://test.db"
    }
  end
  
end
  
