require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Repository::load /" do

  let(:loader){ lambda{ DbAgile::Core::Repository::load(path) } }
  
  describe "on a valid repository /" do
    let(:path){ DbAgile::Fixtures::Core::Repository::repository_path(:test_and_prod) }
    let(:loaded){ loader.call }
    
    it "should not raise any error" do
      loader.should_not raise_error
    end
    
    it "should return a Repository instance" do
      loaded.should be_kind_of(DbAgile::Core::Repository)
    end
    
    it "should have a version number" do
      loaded.version.should_not be_nil
    end
    
  end # valid

  describe "on an unexisting repository /" do
    let(:path){ DbAgile::Fixtures::Core::Repository::repository_path(:unexisting) }
    
    it "should raise an IOError" do
      loader.should raise_error(IOError)
    end
    
  end # unexisting

  describe "on an invalid repository /" do
    let(:path){ DbAgile::Fixtures::Core::Repository::repository_path(:invalid) }
    
    it "should raise an IOError" do
      loader.should raise_error(IOError)
    end
    
  end # invalid

  describe "on an corrupted repository /" do
    let(:path){ DbAgile::Fixtures::Core::Repository::repository_path(:corrupted) }
    
    it "should raise a CorruptedRepositoryError" do
      loader.should raise_error(DbAgile::CorruptedRepositoryError)
    end
    
  end # corrupted

end