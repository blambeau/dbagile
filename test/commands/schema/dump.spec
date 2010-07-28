shared_examples_for("The schema:dump command") do
  
  it "should return a Schema instance" do
    dba.schema_dump.should be_kind_of(DbAgile::Core::Schema::DatabaseSchema)
  end

  it "should display the Schema as a valid YAML string" do
    dba.output_buffer = StringIO.new
    dba.schema_dump
    dba.output_buffer.string.should be_a_valid_yaml_string
  end

end