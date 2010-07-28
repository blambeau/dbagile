require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Repository#config" do

  let(:config){ DbAgile::Fixtures::Core::Repository::config_file(:test_and_prod) }

  describe("When called with an unexisting configuration name") do
    subject{ config.config(:test) }
    specify{
      subject.should be_kind_of(::DbAgile::Core::Database)
      subject.name.should == :test
      subject.uri.should == "sqlite://test.db"
    }
  end

  describe("When called with an unexisting configuration instance") do
    subject{ config.config(config.config(:test)) }
    specify{
      subject.should be_kind_of(::DbAgile::Core::Database)
      subject.name.should == :test
      subject.uri.should == "sqlite://test.db"
    }
  end
  
  describe("When called with a String for uri") do
    subject{ config.config("sqlite://test.db") }
    specify{
      subject.should be_kind_of(::DbAgile::Core::Database)
      subject.name.should == :test
      subject.uri.should == "sqlite://test.db"
    }
  end

  describe("When called with a Regexp for uri") do
    subject{ config.config(/postgres/) }
    specify{
      subject.should be_kind_of(::DbAgile::Core::Database)
      subject.name.should == :production
      subject.uri.should == "postgres://postgres@localhost/test"
    }
  end

  describe("When called with an missing configuration") do
    subject{ config.config(:nosuchone) }
    it{ should be_nil }
  end
  
end