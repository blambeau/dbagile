require File.expand_path('../../../../spec_helper', __FILE__)
describe "DbAgile::Utils::Chain#connect" do
  
  subject{ chain.connect(Fixtures::SayHello) }

  context("when reverse then capitalize") do
    let(:chain){ DbAgile::Utils::Chain[Fixtures::Reverse, Fixtures::Capitalize] }
    specify{
      subject.should be_kind_of(DbAgile::Utils::Chain)
      subject.say_hello("dbagile").should == "Eligabd"
    }
  end
  
  context("when capitalize then reverse") do
    let(:chain){ DbAgile::Utils::Chain[Fixtures::Capitalize, Fixtures::Reverse] }
    specify{
      subject.should be_kind_of(DbAgile::Utils::Chain)
      subject.say_hello("dbagile").should == "eligabD"
    }
  end
  
end
