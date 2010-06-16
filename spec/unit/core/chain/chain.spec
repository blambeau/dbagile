require File.expand_path('../../../../spec_helper', __FILE__)
describe "DbAgile::Core::Chain" do

  context "When created with only one instance member" do
    let(:chain){ DbAgile::Core::Chain.new(Fixtures::SayHello.new) }
    specify{ chain.say_hello("dbagile").should == "dbagile" }
  end
  
  context "When created with only one class member" do
    let(:chain){ DbAgile::Core::Chain.new(Fixtures::SayHello) }
    specify{ chain.say_hello("dbagile").should == "dbagile" }
  end
  
  context "When created with only two members" do
    let(:chain){ DbAgile::Core::Chain.new(Fixtures::Capitalize.new, Fixtures::SayHello.new) }
    specify{ chain.say_hello("dbagile").should == "Dbagile" }
  end
  
  context "When creaed with two members as classes" do
    let(:chain){ DbAgile::Core::Chain.new(Fixtures::Capitalize, Fixtures::SayHello) }
    specify{ chain.say_hello("dbagile").should == "Dbagile" }
  end
  
  context "When created with two members with options as classes" do
    let(:chain){ DbAgile::Core::Chain.new(Fixtures::Capitalize, :upcase, Fixtures::SayHello) }
    specify{ chain.say_hello("dbagile").should == "DBAGILE" }
  end
  
  context "When created with two members through shortcut" do
    let(:chain){ DbAgile::Core::Chain[Fixtures::Capitalize, :upcase, Fixtures::SayHello] }
    specify{ chain.say_hello("dbagile").should == "DBAGILE" }
  end
  
  context "When plugged with only one instance member" do
    let(:chain){ DbAgile::Core::Chain.new }
    specify{ 
      chain.plug(Fixtures::SayHello.new)
      chain.say_hello("dbagile").should == "dbagile" 
    }
  end
  
  context "When plugged different way" do
    let(:chain){ DbAgile::Core::Chain.new(Fixtures::SayHello) }
    specify{ 
      chain.plug(Fixtures::Capitalize, :upcase)
      chain.say_hello("dbagile").should == "DBAGILE" 
    }
  end

end
