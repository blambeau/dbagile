shared_examples_for("The config:add command") do
  
  it "should return the new configuration" do
    dba.config_add(%w{test sqlite://test.db}).should be_kind_of(DbAgile::Core::Configuration)
  end
  
  it "should accept a sqlite relative database" do
    dba.config_add(%w{test test.db}).should be_kind_of(DbAgile::Core::Configuration)
  end
  
  it "should accept a sqlite absolute database" do
    dba.config_add(%w{test sqlite://test.db}).should be_kind_of(DbAgile::Core::Configuration)
  end
  
  it "should raise an error when the name is already in use" do
    dba.config_add(%w{test sqlite://test.db})
    lambda{ dba.config_add(%w{test sqlite://test.db}) }.should raise_error(DbAgile::ConfigNameConflictError)
  end
  
  it "should flush the new configuration" do
    dba.config_add(%w{test sqlite://test.db})
    dba.dup.config_file.has_config?(:test).should be_true
  end
  
  it "should set the configuration as the current one by default" do
    dba.config_add(%w{test sqlite://test.db})
    dba.dup.config_file.current?(:test).should be_true
  end 
  
  it "should not set the configuration as the current one with --no-current" do
    dba.config_add(%w{--no-current test sqlite://test.db})
    dba.dup.config_file.current?(:test).should be_false
  end 
  
end