require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Repository#database" do

  let(:repository){ DbAgile::Fixtures::Core::Repository::repository(:test_and_prod) }

  describe("When called with an unexisting database name") do
    subject{ repository.database(:test) }
    specify{
      subject.should be_kind_of(::DbAgile::Core::Database)
      subject.name.should == :test
      subject.uri.should == "test.db"
    }
  end

  describe("When called with an unexisting database instance") do
    subject{ repository.database(repository.database(:test)) }
    specify{
      subject.should be_kind_of(::DbAgile::Core::Database)
      subject.name.should == :test
      subject.uri.should == "test.db"
    }
  end
  
  describe("When called with a String for uri") do
    subject{ repository.database("test.db") }
    specify{
      subject.should be_kind_of(::DbAgile::Core::Database)
      subject.name.should == :test
      subject.uri.should == "test.db"
    }
  end

  describe("When called with a Regexp for uri") do
    subject{ repository.database(/postgres/) }
    specify{
      subject.should be_kind_of(::DbAgile::Core::Database)
      subject.name.should == :production
      subject.uri.should == "postgres://postgres@localhost/test"
    }
  end

  describe("When called with an missing database") do
    subject{ repository.database(:nosuchone) }
    it{ should be_nil }
  end
  
end