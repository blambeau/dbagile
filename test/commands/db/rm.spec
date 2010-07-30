shared_examples_for("The db:rm command") do
  
  it "should return the repository" do
    dba.db_add(%w{test sqlite://test.db})
    dba.db_rm(%w{test}).should be_kind_of(::DbAgile::Core::Repository)
  end
  
  it "should raise an error when the name is unknown" do
    lambda{ dba.db_rm(%w{test}) }.should raise_error(DbAgile::NoSuchDatabaseError)
  end
  
  it "should save the repository" do
    dba.db_add(%w{test sqlite://test.db})
    dba.db_rm(%w{test})
    dba.dup.repository.has_database?(:test).should be_false
  end

end
