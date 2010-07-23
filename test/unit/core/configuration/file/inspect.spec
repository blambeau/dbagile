require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Configuration::File#inspect" do

  it "should be friendly enough" do 
    file   = DbAgile::Fixtures::Core::Configuration::File::config_file_path(:inspect_friendly)
    config = DbAgile::Fixtures::Core::Configuration::File::config_file(:inspect_friendly)
    config.inspect.should == File.read(file)
  end

end
  
