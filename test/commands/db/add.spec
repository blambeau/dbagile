shared_examples_for("The db:add command") do
  
  it "should return the new database" do
    dba.db_add(%w{test test.db}).should be_kind_of(DbAgile::Core::Database)
  end
  
  it "should accept an absolute database" do
    dba.db_add(%w{test postgres://dbagile@localhost/unexisting}).should be_kind_of(DbAgile::Core::Database)
  end
  
  it "should raise an error when the name is already in use" do
    dba.db_add(%w{test test.db})
    lambda{ dba.db_add(%w{test test.db}) }.should raise_error(DbAgile::DatabaseNameConflictError)
  end
  
  it "should save the repository" do
    dba.db_add(%w{test test.db})
    dba.dup.repository.has_database?(:test).should be_true
  end
  
  it "should set the database as the current one by default" do
    dba.db_add(%w{test test.db})
    dba.dup.repository.current?(:test).should be_true
  end 
  
  it "should not set the database as the current one with --no-current" do
    dba.db_add(%w{--no-current test test.db})
    dba.dup.repository.current?(:test).should be_false
  end 
  
end
