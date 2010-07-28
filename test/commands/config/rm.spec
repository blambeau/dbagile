shared_examples_for("The config:rm command") do
  
  it "should return the repository" do
    dba.config_add(%w{test sqlite://test.db})
    dba.config_rm(%w{test}).should be_kind_of(::DbAgile::Core::Repository)
  end
  
  it "should raise an error when the name is unknown" do
    lambda{ dba.config_rm(%w{test}) }.should raise_error(DbAgile::NoSuchConfigError)
  end
  
  it "should flush the repository" do
    dba.config_add(%w{test sqlite://test.db})
    dba.config_rm(%w{test})
    dba.dup.repository.has_database?(:test).should be_false
  end

end
