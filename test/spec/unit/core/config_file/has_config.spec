require File.expand_path('../../../../spec_helper', __FILE__)
describe "DbAgile::Core::ConfigFile#inspect" do

  let(:file)  { File.expand_path("../example2.dba", __FILE__) }
  let(:config){ DbAgile::Core::ConfigFile.new(file)           }

  describe("When called with an unexisting configuration") do
    subject{ config.has_config?(:test) }
    it{ should be_true }
  end

  describe("When called with an missing configuration") do
    subject{ config.has_config?(:nosuchone) }
    it{ should be_false }
  end
  
end