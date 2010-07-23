require File.expand_path('../fixtures', __FILE__)
require 'yaml'
describe "DbAgile::Core::Schema#to_yaml /" do
  
  it "should work on all fixture files" do
    DbAgile::Fixtures::Core::Schema::each_schema_file{|yaml_file|
      schema = DbAgile::Core::Schema::yaml_file_load(yaml_file)
      schema.to_yaml.should be_a_valid_yaml_string  
      DbAgile::Core::Schema::yaml_load(schema.to_yaml).should be_kind_of(DbAgile::Core::Schema)
    }
  end
  
end