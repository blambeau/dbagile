require File.expand_path('../../../../spec_helper', __FILE__)
describe "DbAgile::Core::Chain#connect" do
  
  subject{ chain.connect(Fixtures::SayHello) }

  context("when reverse then capitalize") do
    let(:chain){ DbAgile::Core::Chain[Fixtures::Reverse, Fixtures::Capitalize] }
    specify{
      subject.should be_kind_of(DbAgile::Core::Chain)
      subject.say_hello("dbagile").should == "Eligabd"
    }
  end
  
  context("when capitalize then reverse") do
    let(:chain){ DbAgile::Core::Chain[Fixtures::Capitalize, Fixtures::Reverse] }
    specify{
      subject.should be_kind_of(DbAgile::Core::Chain)
      subject.say_hello("dbagile").should == "eligabD"
    }
  end
  
end
