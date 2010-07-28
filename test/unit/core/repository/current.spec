require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Repository#current?" do

  let(:config){ DbAgile::Fixtures::Core::Repository::config_file(:test_and_prod) }

  describe("When called with an existing but not current configuration (name)") do
    subject{ config.current?(:test) }
    it{ should == false }
  end

  describe("When called with an existing and current configuration (name)") do
    subject{ config.current?(:production) }
    it{ should == true }
  end

  describe("When called with an existing but not current configuration (instance)") do
    subject{ config.current?(config.database(:test)) }
    it{ should == false }
  end

  describe("When called with an existing and current configuration (instance)") do
    subject{ config.current?(config.database(:production)) }
    it{ should == true }
  end

  describe("When called with an missing configuration (name)") do
    subject{ config.current?(:nosuchone) }
    it{ should be_nil }
  end
  
end