require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Repository#current?" do

  let(:database){ DbAgile::Fixtures::Core::Repository::repository(:test_and_prod) }

  describe("When called with an existing but not current database (name)") do
    subject{ database.current?(:test) }
    it{ should == false }
  end

  describe("When called with an existing and current database (name)") do
    subject{ database.current?(:production) }
    it{ should == true }
  end

  describe("When called with an existing but not current database (instance)") do
    subject{ database.current?(database.database(:test)) }
    it{ should == false }
  end

  describe("When called with an existing and current database (instance)") do
    subject{ database.current?(database.database(:production)) }
    it{ should == true }
  end

  describe("When called with an missing database (name)") do
    subject{ database.current?(:nosuchone) }
    it{ should be_nil }
  end
  
end