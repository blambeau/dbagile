shared_examples_for("The schema:check command") do
  
  describe "when the shema is valid" do
    
    it "should return a Schema instance" do
      dba.schema_check.should be_kind_of(DbAgile::Core::Schema::DatabaseSchema)
    end

  end

end