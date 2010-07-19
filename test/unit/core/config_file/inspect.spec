require File.expand_path('../../../fixtures', __FILE__)
describe "DbAgile::Core::ConfigFile#inspect" do

  describe "On examples files" do
    Dir[File.expand_path('../*.dba', __FILE__)].each do |file|
      specify{ 
        config_file = DbAgile::Core::ConfigFile.new(file)
        config_file.file.should == file
        config_file.inspect.should == File.read(file)
      }
    end
  end

end
  
