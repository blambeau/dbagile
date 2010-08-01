shared_examples_for("The db:use command") do
  
  it "should return the current database" do
    dba.db_add(%w{test test.db})
    dba.db_use(%w{test}).should be_kind_of(::DbAgile::Core::Database)
  end

  it "should raise an error if the database is unknown" do
    lambda{ dba.db_use(%w{test}) }.should raise_error(DbAgile::NoSuchDatabaseError)
  end

  it "should save the repository" do
    dba.db_add(%w{--no-current test test.db})
    dba.db_use(%w{test})
    dba.dup.repository.current?(:test).should be_true
  end
  
end