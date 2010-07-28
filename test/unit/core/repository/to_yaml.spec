require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Repository#to_yaml" do

  let(:repo){ DbAgile::Fixtures::Core::Repository::repository(:test_and_prod) }

  it "should return a valid yaml string" do 
    repo.should_not be_nil
    res = repo.to_yaml
    res.should be_a_valid_yaml_string
    DbAgile::Core::Repository.from_yaml(res).should be_kind_of(DbAgile::Core::Repository)
  end

end
  
