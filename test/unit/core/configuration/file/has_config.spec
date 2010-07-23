require File.expand_path('../../../../fixtures', __FILE__)
describe "DbAgile::Core::Configuration::File#has_config?" do

  let(:file)  { File.expand_path("../example2.dba", __FILE__) }
  let(:config){ DbAgile::Core::Configuration::File.new(file)           }

  describe("When called with an unexisting configuration") do
    subject{ config.has_config?(:test) }
    it{ should == true }
  end

  describe("When called with an missing configuration") do
    subject{ config.has_config?(:nosuchone) }
    it{ should == false }
  end
  
end