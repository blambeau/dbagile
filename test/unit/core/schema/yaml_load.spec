require File.expand_path('../../../fixtures', __FILE__)
describe "DbAgile::Core::Schema#relvars" do
  
  let(:spa){ File.expand_path("../fixtures/sap.yaml", __FILE__) }
  
  it "should be YAML loadable from a file" do
    DbAgile::Core::Schema::yaml_file_load(spa).should be_kind_of(DbAgile::Core::Schema)
  end
  
  it "should be YAML loadable from an IO" do
    File.open(spa, "r") do |io|
      DbAgile::Core::Schema::yaml_file_load(io).should be_kind_of(DbAgile::Core::Schema)
    end
  end
  
  it "should be YAML loadable from an String" do
    DbAgile::Core::Schema::yaml_load(File.read(spa)).should be_kind_of(DbAgile::Core::Schema)
  end
  
end