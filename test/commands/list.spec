shared_examples_for("The list command") do
  
  it "should return the configuration file instance" do
    DbAgile::command(environment) do |env, api|
      api.list.should be_kind_of(DbAgile::Core::ConfigFile)
    end
  end
  
  it "should print the configurations" do
    DbAgile::command(environment) do |env, api|
      api.list
      env.output_buffer.join('').should =~ /Available databases/
    end
  end
  
  it "should print a friendly error message when no config" do
    DbAgile::command(environment) do |env, api|
      env.config_file_path = empty_config_path
      api.list
      env.output_buffer.join('').should =~ /No database configuration found/
    end
  end
  
end
