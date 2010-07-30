shared_examples_for("The db:list command") do
  
  describe "/ on a non empty repository /" do
    
    it "should return the repository instance" do
      dba.db_list.should be_kind_of(DbAgile::Core::Repository)
    end
  
    it "should print the databases" do
      dba.db_list
      dba.output_buffer.string.should =~ /Available databases/
    end
    
  end
  
  describe "/ on an empty repository /" do

    before{ dba.repository_path = DbAgile::Fixtures::ensure_empty_repository! }
    
    it "should print a friendly error message when no database" do
      dba.db_list
      dba.output_buffer.string.should =~ /No database found/
    end
    
  end
  
end
