require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Repository#inspect" do

  it "should be friendly enough" do 
    file   = DbAgile::Fixtures::Core::Repository::repository_path(:inspect_friendly)
    config = DbAgile::Fixtures::Core::Repository::repository(:inspect_friendly)
    config.inspect.should == File.read(file)
  end

end
  
