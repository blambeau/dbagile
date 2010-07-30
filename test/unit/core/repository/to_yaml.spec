require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Repository#to_yaml /" do

  let(:path){ DbAgile::Fixtures::Core::Repository::repository_path(:test_and_prod) }
  let(:repo){ DbAgile::Core::Repository::load(path) }

  it "should return a valid yaml string" do 
    repo.to_yaml.should be_a_valid_yaml_string
  end
  
  it "should be such that a repository could be created" do
    got = DbAgile::Core::Repository.send(:from_yaml, repo.to_yaml, path)
    got.should be_kind_of(DbAgile::Core::Repository)
  end

end
  
