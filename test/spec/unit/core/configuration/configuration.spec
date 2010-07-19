require File.expand_path('../../../../spec_helper', __FILE__)
describe "DbAgile::Core::Configuration" do
  
  context "when called without configuration block at all" do
    let(:config){ DbAgile::Core::Configuration.new }
    specify{
      config.connect("sqlite://test.db").should be_kind_of(DbAgile::Core::Connection)
    }
  end
  
  context "when called with a configuration block" do
    let(:config){ 
      DbAgile::Core::Configuration.new{
        uri "sqlite://test.db"
      }
    }
    specify{
      c = config.connect
      c.should be_kind_of(DbAgile::Core::Connection)
      c.transaction do |t|
        t.should be_kind_of(DbAgile::Core::Transaction)
      end
    }
  end
  
end
  
