require File.expand_path('../../../../spec_helper', __FILE__)
describe "DbAgile::Core::ConfigFile#config" do

  let(:file)  { File.expand_path("../example2.dba", __FILE__) }
  let(:config){ DbAgile::Core::ConfigFile.new(file)           }

  describe("When called with an unexisting configuration") do
    subject{ config.config(:test) }
    specify{
      subject.should be_kind_of(::DbAgile::Core::Configuration)
      subject.name.should == :test
      subject.uri.should == "sqlite://test.db"
    }
  end

  describe("When called with an missing configuration") do
    subject{ config.config(:nosuchone) }
    it{ should be_nil }
  end
  
end