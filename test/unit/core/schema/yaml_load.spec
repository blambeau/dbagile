require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Schema::yaml_load /" do
  
  let(:yaml_file){ DbAgile::Fixtures::Core::Schema::schema_file(:suppliers_and_parts) }
  let(:with_views){ DbAgile::Fixtures::Core::Schema::schema_file(:views) }
  
  it "should be YAML loadable from a file" do
    DbAgile::Core::Schema::yaml_file_load(yaml_file).should be_kind_of(DbAgile::Core::Schema::DatabaseSchema)
  end

  it "should be YAML loadable from an IO" do
    File.open(yaml_file, "r") do |io|
      DbAgile::Core::Schema::yaml_file_load(io).should be_kind_of(DbAgile::Core::Schema::DatabaseSchema)
    end
  end

  it "should be YAML loadable from an String" do
    DbAgile::Core::Schema::yaml_load(File.read(yaml_file)).should be_kind_of(DbAgile::Core::Schema::DatabaseSchema)
  end
  
  it 'should support views' do
    DbAgile::Core::Schema::yaml_file_load(with_views).should be_kind_of(DbAgile::Core::Schema::DatabaseSchema)
  end
  
end