require File.expand_path('../../../../spec_helper', __FILE__)
describe "DbAgile::Utils::Connector" do
  
  let(:connector){ ::DbAgile::Utils::Connector.new }
  before{
    connector.plug(::Fixtures::Reverse)
    connector.plug(:upcased, ::Fixtures::Upcase)
    connector.plug(:capitalized, ::Fixtures::Capitalize)
  }
  
  specify {
    conn = connector.connect(::Fixtures::SayHello)
    conn.main_delegate.say_hello("dbagile").should == "eligabd"
    conn.find_delegate(:noone).say_hello("dbagile").should == "eligabd"
    conn.find_delegate(:upcased).say_hello("dbagile").should == "ELIGABD"
    conn.find_delegate(:capitalized).say_hello("dbagile").should == "eligabD"
  }
  
end