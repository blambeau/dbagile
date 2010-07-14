require File.expand_path('../../../../spec_helper', __FILE__)
describe "DbAgile::Core::ConfigFile#current?" do

  let(:file)  { File.expand_path("../example2.dba", __FILE__) }
  let(:config){ DbAgile::Core::ConfigFile.new(file)           }

  describe("When called with an existing but not current configuration (name)") do
    subject{ config.current?(:test) }
    it{ should == false }
  end

  describe("When called with an existing and current configuration (name)") do
    subject{ config.current?(:production) }
    it{ should == true }
  end

  describe("When called with an existing but not current configuration (instance)") do
    subject{ config.current?(config.config(:test)) }
    it{ should == false }
  end

  describe("When called with an existing and current configuration (instance)") do
    subject{ config.current?(config.config(:production)) }
    it{ should == true }
  end

  describe("When called with an missing configuration (name)") do
    subject{ config.current?(:nosuchone) }
    it{ should be_nil }
  end
  
end