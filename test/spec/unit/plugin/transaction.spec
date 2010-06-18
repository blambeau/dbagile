require File.expand_path('../../../spec_helper', __FILE__)
describe "::DbAgile::Plugin#transaction" do
  
  let(:plugin){ DbAgile::Core::Chain[DbAgile::Plugin, DbAgile::MemoryAdapter] }
  
  specify{
    s = plugin.transaction do
      12
    end
    s.should == 12
  }
end