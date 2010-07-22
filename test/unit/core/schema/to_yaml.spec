require File.expand_path('../../../fixtures', __FILE__)
require 'yaml'
describe "DbAgile::Core::Schema#to_yaml" do
  
  let(:supplier_and_parts){ File.expand_path("../fixtures/supplier_and_parts.yaml", __FILE__) }
  let(:schema)            { DbAgile::Core::Schema::yaml_file_load(supplier_and_parts)         }
  
  it "should return a valid YAML string" do
    schema.to_yaml.should be_a_valid_yaml_string
  end
  
  it "returned string should be loadable as a Schema" do
    puts schema.to_yaml
    DbAgile::Core::Schema::yaml_load(schema.to_yaml).should be_kind_of(DbAgile::Core::Schema)
  end
  
end