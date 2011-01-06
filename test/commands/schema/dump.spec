shared_examples_for("The schema:dump command") do
  
  let(:invalid){ File.expand_path('../fixtures/invalid.yaml', __FILE__) }
  let(:announced){ File.expand_path('../fixtures/announced.yaml', __FILE__) }
  
  it "should return a Schema instance" do
    dba.schema_dump.should be_kind_of(DbAgile::Core::Schema::DatabaseSchema)
  end

  it "should display the Schema as a valid YAML string" do
    dba.output_buffer = StringIO.new
    dba.schema_dump
    dba.output_buffer.string.should be_a_valid_yaml_string
  end
  
  it "should raise an error on invalid schema" do
    lambda{ dba.schema_dump [ invalid ] }.should raise_error(DbAgile::SchemaSemanticsError)
  end

  it "should not raise an error on invalid schema with --no-check" do
    lambda{ dba.schema_dump ['--no-check', invalid] }.should_not raise_error(DbAgile::SchemaSemanticsError)
  end
  
  it "should support an --include option" do
    res = dba.schema_dump [ announced, "--include=logical" ]
    res.should be_kind_of(DbAgile::Core::Schema::DatabaseSchema)
    res.logical.should_not be_empty
    res.physical.should be_empty
  end

  it "should support an --exclude option" do
    res = dba.schema_dump [ announced, "--exclude=logical" ]
    res.should be_kind_of(DbAgile::Core::Schema::DatabaseSchema)
    res.logical.should be_empty
    res.physical.should_not be_empty
  end
  
  it "should support --include and --exclude with a 'include and NOT exclude' semantics" do
    res = dba.schema_dump [ announced, "--include=logical", "--exclude=constraint"]
    res.should be_kind_of(DbAgile::Core::Schema::DatabaseSchema)
    res.logical.should_not be_empty
    res.logical[:SUPPLIES].constraints.should be_empty
    res.physical.should be_empty
  end

end