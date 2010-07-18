shared_examples_for("The rm command") do
  
  it "should return the config file" do
    dba.config_file_path = empty_config_path
    dba.add(%w{test sqlite://test.db})
    dba.rm(%w{test}).should be_kind_of(::DbAgile::Core::ConfigFile)
  end
  
  it "should raise an error when the name is unknown" do
    dba.config_file_path = empty_config_path
    lambda{ dba.rm(%w{test}) }.should raise_error(DbAgile::NoSuchConfigError)
  end
  
  it "should flush the new configuration" do
    dba.config_file_path = empty_config_path
    dba.add(%w{test sqlite://test.db})
    dba.rm(%w{test})
    dba.dup.config_file.has_config?(:test).should be_false
  end

end
