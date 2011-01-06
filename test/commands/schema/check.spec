shared_examples_for("The schema:check command") do
  
  it "should return a Schema and Errors on valid schema" do
    schema, errors = dba.schema_check
    schema.should be_kind_of(DbAgile::Core::Schema::DatabaseSchema)
    errors.should be_kind_of(DbAgile::SchemaSemanticsError)
    errors.should be_empty
  end
    
  it "should return a Schema and Errors on invalid schema" do
    schema, errors = dba.schema_check [ File.expand_path('../fixtures/invalid.yaml', __FILE__) ]
    schema.should be_kind_of(DbAgile::Core::Schema::DatabaseSchema)
    errors.should be_kind_of(DbAgile::SchemaSemanticsError)
    errors.should_not be_empty
  end

  it "should support a --stdin option" do
    old_buffer = dba.input_buffer
    begin
      text = File.read(File.expand_path('../fixtures/invalid.yaml', __FILE__))
      dba.input_buffer = StringIO.new text
      schema, errors = dba.schema_check [ "--stdin" ]
      schema.should be_kind_of(DbAgile::Core::Schema::DatabaseSchema)
      errors.should be_kind_of(DbAgile::SchemaSemanticsError)
      errors.should_not be_empty
      schema.schema_identifier.should == "--stdin"
    ensure
      dba.input_buffer = old_buffer
    end
  end

end