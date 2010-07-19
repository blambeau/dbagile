require File.expand_path('../../../fixtures', __FILE__)
describe "DbAgile::Core::Connector" do
  
  let(:connector){ ::DbAgile::Core::Connector.new }
  before(:each){
    connector.plug(::DbAgile::Fixtures::Reverse)
    connector.plug(:upcased, ::DbAgile::Fixtures::Upcase)
    connector.plug(:capitalized, ::DbAgile::Fixtures::Capitalize)
  }
  
  specify("it should behave correctly") {
    conn = connector.connect(::DbAgile::Fixtures::SayHello)
    conn.connected?.should be_true
    conn.main_delegate.say_hello("dbagile").should == "eligabd"
    conn.find_delegate(:noone).say_hello("dbagile").should == "eligabd"
    conn.find_delegate(:upcased).say_hello("dbagile").should == "ELIGABD"
    conn.find_delegate(:capitalized).say_hello("dbagile").should == "eligabD"
  }
  
  specify("it should support hot plugs") {
    conn = connector.connect(::DbAgile::Fixtures::SayHello)
    conn.connected?.should be_true
    conn.plug(:basic, ::DbAgile::Fixtures::Upcase)
    conn.find_delegate(:basic).say_hello("dbagile").should == "ELIGABD"
  }

end