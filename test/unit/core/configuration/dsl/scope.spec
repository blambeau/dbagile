require File.expand_path('../../../../fixtures', __FILE__)
describe "DbAgile::Core::Configuration::DSL's scope" do
  
  it "should resolve File correctly" do
    DbAgile::Core::Configuration::DSL.instance_eval{ File }.should == ::File
    DbAgile::Core::Configuration::DSL.new.instance_eval{ File }.should == ::File
  end
  
end