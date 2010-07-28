shared_examples_for("The config:use command") do
  
  it "should return the current database" do
    dba.config_add(%w{test sqlite://test.db})
    dba.config_use(%w{test}).should be_kind_of(::DbAgile::Core::Database)
  end

  it "should raise an error if the database is unknown" do
    lambda{ dba.config_use(%w{test}) }.should raise_error(DbAgile::NoSuchConfigError)
  end

  it "should flush the repository" do
    dba.config_add(%w{--no-current test sqlite://test.db})
    dba.config_use(%w{test})
    dba.dup.repository.current?(:test).should be_true
  end
  
end