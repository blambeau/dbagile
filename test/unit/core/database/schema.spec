require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Schema#schema" do
  
  subject{ config.schema }
  
  describe "when one schema file has been installed" do
    let(:config){ DbAgile::Fixtures::Core::Database::config(:one_schema_file) }
    it{ should be_kind_of(DbAgile::Core::Schema::DatabaseSchema) }
    it{ should_not be_empty }
  end
  
  describe "when many schema files have been installed" do
    let(:config){ DbAgile::Fixtures::Core::Database::config(:many_schema_files) }
    it{ should be_kind_of(DbAgile::Core::Schema::DatabaseSchema) }
    it{ should_not be_empty }
  end
  
end