shared_examples_for("The use command") do
  
  it "should return the current configuration" do
    DbAgile::command(environment) do |env, api|
      env.config_file_path = empty_config_path
      api.add(%w{test sqlite://test.db})
      api.use(%w{test}).should be_kind_of(::DbAgile::Core::Configuration)
    end
  end

  it "should raise an error if the configuration is unknown" do
    DbAgile::command(environment) do |env, api|
      env.config_file_path = empty_config_path
      lambda{ api.use(%w{test}) }.should raise_error(DbAgile::NoSuchConfigError)
    end
  end

  it "should flush the config file" do
    DbAgile::command(environment) do |env, api|
      env.config_file_path = empty_config_path
      api.add(%w{--no-current test sqlite://test.db})
      api.use(%w{test})
    end
    DbAgile::command(environment.dup) do |env, api|
      env.config_file.current?(:test).should be_true
    end
  end
  
end