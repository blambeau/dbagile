shared_examples_for("The repo:list command") do
  
  it "should return the repository instance" do
    dba.repo_list.should be_kind_of(DbAgile::Core::Repository)
  end
  
  it "should print the databases" do
    dba.repo_list
    dba.output_buffer.string.should =~ /Available databases/
  end
  
  it "should print a friendly error message when no database" do
    dba.repository_path = empty_repository_path
    dba.repo_list
    dba.output_buffer.string.should =~ /No database found/
  end
  
end
