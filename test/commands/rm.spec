shared_examples_for("The rm command") do
  
  it "should return the config file" do
    DbAgile::command(environment) do |env, api|
      env.config_file_path = empty_config_path
      api.add(%w{test sqlite://test.db})
      api.rm(%w{test}).should be_kind_of(::DbAgile::Core::ConfigFile)
    end
  end
  
  it "should raise an error when the name is unknown" do
    DbAgile::command(environment) do |env, api|
      env.config_file_path = empty_config_path
      lambda{ api.rm(%w{test}) }.should raise_error(DbAgile::NoSuchConfigError)
    end
  end
  
  it "should flush the new configuration" do
    DbAgile::command(environment) do |env, api|
      env.config_file_path = empty_config_path
      api.add(%w{test sqlite://test.db})
      api.rm(%w{test})
    end
    DbAgile::command(environment.dup) do |env, api|
      env.config_file.has_config?(:test).should be_false
    end
  end

end
