require File.expand_path('../../../fixtures', __FILE__)
describe "DbAgile::Core::Chain" do

  context "When created with only one instance member" do
    let(:chain){ DbAgile::Core::Chain.new(DbAgile::Fixtures::SayHello.new) }
    specify{ chain.say_hello("dbagile").should == "dbagile" }
  end
  
  context "When created with only one class member" do
    let(:chain){ DbAgile::Core::Chain.new(DbAgile::Fixtures::SayHello) }
    specify{ chain.say_hello("dbagile").should == "dbagile" }
  end
  
  context "When created with only two members" do
    let(:chain){ DbAgile::Core::Chain.new(DbAgile::Fixtures::Capitalize.new, DbAgile::Fixtures::SayHello.new) }
    specify{ chain.say_hello("dbagile").should == "Dbagile" }
  end
  
  context "When creaed with two members as classes" do
    let(:chain){ DbAgile::Core::Chain.new(DbAgile::Fixtures::Capitalize, DbAgile::Fixtures::SayHello) }
    specify{ chain.say_hello("dbagile").should == "Dbagile" }
  end
  
  context "When created with two members with options as classes" do
    let(:chain){ DbAgile::Core::Chain.new(DbAgile::Fixtures::Capitalize, :upcase, DbAgile::Fixtures::SayHello) }
    specify{ chain.say_hello("dbagile").should == "DBAGILE" }
  end
  
  context "When created with two members through shortcut" do
    let(:chain){ DbAgile::Core::Chain[DbAgile::Fixtures::Capitalize, :upcase, DbAgile::Fixtures::SayHello] }
    specify{ chain.say_hello("dbagile").should == "DBAGILE" }
  end
  
  context "When plugged with only one instance member" do
    let(:chain){ DbAgile::Core::Chain.new }
    specify{ 
      chain.plug(DbAgile::Fixtures::SayHello.new)
      chain.say_hello("dbagile").should == "dbagile" 
    }
  end
  
  context "When plugged different way" do
    let(:chain){ DbAgile::Core::Chain.new(DbAgile::Fixtures::SayHello) }
    specify{ 
      chain.plug(DbAgile::Fixtures::Capitalize, :upcase)
      chain.say_hello("dbagile").should == "DBAGILE" 
    }
  end

  context "When blocks are used" do
    let(:chain){ DbAgile::Core::Chain.new(DbAgile::Fixtures::SayHello.new) }
    specify{ 
      chain.del_to_block{ "hello" }.should == "hello" 
    }
  end

end
