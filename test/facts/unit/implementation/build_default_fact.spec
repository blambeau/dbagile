require File.expand_path('../../unit_helper.rb', __FILE__)
describe "Facts::Database::Implementation#build_default_fact" do
  
  let(:imp){ Object.new.extend(Facts::Database::Implementation) }
  
  it "should support a Symbol as a key" do
    imp.build_default_fact(:name, "Facts").should == "Facts"
    imp.build_default_fact(:name, {:name => "Facts"}).should == "Facts"
    imp.build_default_fact(:name){|who| "Facts"}.should == "Facts"
  end
  
  it "should support an array of Symbols as a key" do
    imp.build_default_fact([ :name ], "Facts").should == {:name => "Facts"}
    imp.build_default_fact([ :name ], {:name => "Facts"}).should == {:name => "Facts"}
    imp.build_default_fact([ :name ]){|who| "Facts"}.should == {:name => "Facts"}
  end

  it "should never return nils when used in second form" do
    imp.build_default_fact([ :name ], nil).should == {}
    imp.build_default_fact([ :name ], {}).should == {}
    imp.build_default_fact([ :name ]){|who| nil}.should == {}
  end

  it "support the great:false example" do
    imp.build_default_fact(:great, false).should == false
  end

  it "support the great:true example" do
    imp.build_default_fact(:great){|who| true}.should == true
  end

end