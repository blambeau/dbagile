require File.expand_path('../../../spec_helper', __FILE__)
require 'flexidb/engine'
describe "DbAgile::Engine::Command" do
  
  before do
    class C1 < DbAgile::Engine::Command; 
      names "c1"; 
      synopsis "synopsis of c1"
    end;  
    class C2 < DbAgile::Engine::Command; names "c2"; end;  
  end
  
  it "should allow specifying different names for different commands" do
    C1.names.should == ["c1"]
    C2.names.should == ["c2"]
  end
  
  it "should allow have a official name" do
    C1.name.should == "c1"
    C2.name.should == "c2"
  end
  
  it "should allow specifying different names on instance" do
    C1.new.names.should == ["c1"]
    C2.new.names.should == ["c2"]
  end
  
  it "should allow have a official name on instance" do
    C1.new.name.should == "c1"
    C2.new.name.should == "c2"
  end
  
  it "should support a synopsis on both class and instance" do
    C1.synopsis.should == "synopsis of c1"
    C1.new.synopsis.should == "synopsis of c1"
  end
  
end

