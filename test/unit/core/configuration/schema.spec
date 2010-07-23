require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Schema#schema" do
  
  subject{ config.schema }
  
  describe "when no schema file has been installed" do
    let(:config){ DbAgile::Fixtures::Core::Configuration::config(:simple) }
    it{ should be_nil }
  end
  
  describe "when one schema file has been installed" do
    let(:config){ DbAgile::Fixtures::Core::Configuration::config(:one_schema_file) }
    it{ should be_kind_of(DbAgile::Core::Schema) }
    it{ should_not be_empty }
  end
  
  describe "when many schema files have been installed" do
    let(:config){ DbAgile::Fixtures::Core::Configuration::config(:many_schema_files) }
    it{ should be_kind_of(DbAgile::Core::Schema) }
    it{ should_not be_empty }
  end
  
end