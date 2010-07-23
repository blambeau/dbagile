require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Configuration::File#has_config?" do

  let(:config){ DbAgile::Fixtures::Core::Configuration::File::config_file(:test_and_prod) }

  describe("When called with an unexisting configuration") do
    subject{ config.has_config?(:test) }
    it{ should == true }
  end

  describe("When called with an missing configuration") do
    subject{ config.has_config?(:nosuchone) }
    it{ should == false }
  end
  
end