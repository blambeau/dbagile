shared_examples_for("The config:list command") do
  
  it "should return the configuration file instance" do
    dba.config_list.should be_kind_of(DbAgile::Core::Configuration::File)
  end
  
  it "should print the configurations" do
    dba.config_list
    dba.output_buffer.string.should =~ /Available databases/
  end
  
  it "should print a friendly error message when no config" do
    dba.config_file_path = empty_config_path
    dba.config_list
    dba.output_buffer.string.should =~ /No database configuration found/
  end
  
end
