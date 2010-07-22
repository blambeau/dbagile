require File.expand_path('../../../fixtures', __FILE__)
describe "DbAgile::Core::Schema#relvars" do
  
  Dir[File.expand_path("../fixtures/*.yaml", __FILE__)].each{|yaml_file|
    
    it "should be YAML loadable from a #{yaml_file}" do
      DbAgile::Core::Schema::yaml_file_load(yaml_file).should be_kind_of(DbAgile::Core::Schema)
    end
  
    it "should be YAML loadable from an IO" do
      File.open(yaml_file, "r") do |io|
        DbAgile::Core::Schema::yaml_file_load(io).should be_kind_of(DbAgile::Core::Schema)
      end
    end
  
    it "should be YAML loadable from an String" do
      DbAgile::Core::Schema::yaml_load(File.read(yaml_file)).should be_kind_of(DbAgile::Core::Schema)
    end
    
  }
  
end