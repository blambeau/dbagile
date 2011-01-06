shared_examples_for("The repo:create command") do
  
  let(:empty_path){ DbAgile::Fixtures::repository_path(:empty) }
    
  describe "when the repository already exists" do
    
    before { dba.repository_path = DbAgile::Fixtures::ensure_empty_repository! }

    it "should raise an error without --force" do
      lambda{ dba.repo_create [ dba.repository_path ] }.should raise_error(IOError)
    end

    it "should not raise an error with --force" do
      lambda{ dba.repo_create [ "--force", dba.repository_path ] }.should_not raise_error(IOError)
    end

  end

  describe "when the repository does not exist" do
    
    before { FileUtils.rm_rf(empty_path) }
    
    it "should create the repo without --force" do
      dba.repo_create [ dba.repository_path ]
      dba.repository.should be_kind_of(DbAgile::Core::Repository)
    end

  end
  
end