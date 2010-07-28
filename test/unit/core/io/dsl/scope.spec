require File.expand_path('../../../../fixtures', __FILE__)
describe "DbAgile::Core::IO::DSL's scope" do
  
  it "should resolve File correctly" do
    DbAgile::Core::IO::DSL.instance_eval{ File }.should == ::File
    DbAgile::Core::IO::DSL.new.instance_eval{ File }.should == ::File
  end
  
end