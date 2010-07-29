shared_examples_for("The schema:check command") do
  
  describe "when the shema is valid" do
    
    it "should return a Schema and Errors" do
      schema, errors = dba.schema_check
      schema.should be_kind_of(DbAgile::Core::Schema::DatabaseSchema)
      errors.should be_kind_of(DbAgile::SchemaSemanticsError)
      errors.should be_empty
    end

  end

  describe "when the shema is invalid" do

    it "should return a Schema and Errors" do
      schema, errors = dba.schema_check [ File.expand_path('../fixtures/invalid.yaml', __FILE__) ]
      schema.should be_kind_of(DbAgile::Core::Schema::DatabaseSchema)
      errors.should be_kind_of(DbAgile::SchemaSemanticsError)
      errors.should_not be_empty
    end

  end

end