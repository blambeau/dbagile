require File.expand_path('../../../fixtures', __FILE__)
describe "DbAgile::Core::Chain#connect" do
  
  subject{ chain.connect(DbAgile::Fixtures::SayHello) }

  context("when reverse then capitalize") do
    let(:chain){ DbAgile::Core::Chain[DbAgile::Fixtures::Reverse, DbAgile::Fixtures::Capitalize] }
    specify{
      subject.should be_kind_of(DbAgile::Core::Chain)
      subject.say_hello("dbagile").should == "Eligabd"
    }
  end
  
  context("when capitalize then reverse") do
    let(:chain){ DbAgile::Core::Chain[DbAgile::Fixtures::Capitalize, DbAgile::Fixtures::Reverse] }
    specify{
      subject.should be_kind_of(DbAgile::Core::Chain)
      subject.say_hello("dbagile").should == "eligabD"
    }
  end
  
end
