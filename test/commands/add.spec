shared_examples_for("The add command") do
  
  it "should return the new configuration" do
    DbAgile::command(environment) do |env, api|
      env.config_file_path = empty_config_path
      api.add(%w{test sqlite://test.db}).should be_kind_of(DbAgile::Core::Configuration)
    end
  end
  
  it "should raise an error when the name is already in use" do
    DbAgile::command(environment) do |env, api|
      env.config_file_path = empty_config_path
      api.add(%w{test sqlite://test.db})
      lambda{ api.add(%w{test sqlite://test.db}) }.should raise_error(DbAgile::ConfigNameConflictError)
    end
  end
  
  it "should flush the new configuration" do
    DbAgile::command(environment) do |env, api|
      env.config_file_path = empty_config_path
      api.add(%w{test sqlite://test.db})
    end
    DbAgile::command(environment.dup) do |env, api|
      env.config_file.has_config?(:test).should be_true
    end
  end
  
  it "should set the configuration as the current one by default" do
    DbAgile::command(environment) do |env, api|
      env.config_file_path = empty_config_path
      api.add(%w{test sqlite://test.db})
    end
    DbAgile::command(environment.dup) do |env, api|
      env.config_file.current?(:test).should be_true
    end
  end 
  
  it "should not set the configuration as the current one with --no-current" do
    DbAgile::command(environment) do |env, api|
      env.config_file_path = empty_config_path
      api.add(%w{--no-current test sqlite://test.db})
    end
    DbAgile::command(environment.dup) do |env, api|
      env.config_file.current?(:test).should be_false
    end
  end 
  
end
