require File.expand_path('../../../../spec_helper', __FILE__)
describe "DbAgile::Core::Configuration" do
  
  context "when called without configuration block at all" do
    let(:config){ DbAgile::Core::Configuration.new }
    specify{
      config.connect("memory://test.db").should be_kind_of(DbAgile::Core::Connection)
    }
  end
  
  context "when called with a configuration block" do
    let(:config){ 
      DbAgile::Core::Configuration.new{
        uri "memory://test.db"
      }
    }
    specify{
      config.connect.should be_kind_of(DbAgile::Core::Connection)
    }
  end
  
end
  
