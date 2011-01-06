require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Repository::create! /" do
  
  describe "on an unexisting folder" do
    before{ FileUtils.rm_rf(path) }
    after { FileUtils.rm_rf(path) }
    let(:path){ DbAgile::Fixtures::Core::Repository::repository_path(:unexisting) }
    
    it "should not raise any error" do
      lambda{ DbAgile::Core::Repository::create!(path) }.should_not raise_error
    end
    
    it "should return a repository instance with correct version number" do
      repo = DbAgile::Core::Repository::create!(path)
      repo.should be_kind_of(DbAgile::Core::Repository)
      repo.version.should == DbAgile::VERSION
    end
    
    it "should create a reloadable repository with correct version number" do
      created = DbAgile::Core::Repository::create!(path)
      created.send(:version=, "0.99.0")
      created.save!
      reloaded = DbAgile::Core::Repository::load(path)
      reloaded.version.should == "0.99.0"
    end
    
  end
  
  

end