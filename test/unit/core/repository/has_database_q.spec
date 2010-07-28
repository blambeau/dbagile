require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Repository#has_database?" do

  let(:config){ DbAgile::Fixtures::Core::Repository::repository(:test_and_prod) }

  describe("When called with an unexisting configuration") do
    subject{ config.has_database?(:test) }
    it{ should == true }
  end

  describe("When called with an missing configuration") do
    subject{ config.has_database?(:nosuchone) }
    it{ should == false }
  end
  
end