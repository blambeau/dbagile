require File.expand_path('../../unit_helper.rb', __FILE__)
describe "Facts::Database::Implementation#build_fact" do
  
  let(:imp){ Object.new.extend(Facts::Database::Implementation) }
  let(:tuple){ {:name => "Facts", :version => Facts::VERSION} }
  
  it "should support a Symbol as a key" do
    imp.build_fact(tuple, :name).should == "Facts"
    imp.build_fact(tuple, :name).should == "Facts"
    imp.build_fact(tuple, :name).should == "Facts"
  end
  
  it "should support an array of Symbols as a key" do
    imp.build_fact(tuple, [ :name ]).should == {:name => "Facts"}
    imp.build_fact(tuple, [ :name, :version ]).should == tuple
  end
  
  it "should support default values with Symbol form" do
    imp.build_fact(tuple, :noname, "NoFacts").should == "NoFacts"
    imp.build_fact(tuple, :noname, {:noname => "NoFacts"}).should == "NoFacts"
    imp.build_fact(tuple, :noname){ "NoFacts" }.should == "NoFacts"
  end

  it "should support default values with Array of Symbols form" do
    expected = {:name => "Facts", :noname => "NoFacts"}
    imp.build_fact(tuple, [ :name, :noname ], {:noname => "NoFacts"}).should == expected
    imp.build_fact(tuple, [ :name, :noname ], "NoFacts").should == expected
    imp.build_fact(tuple, [ :name, :noname ]){|who| "NoFacts"}.should == expected
  end

  it "should support the great:false example" do
    imp.build_fact({}, :great, false).should == false
  end

  it "should support the great:true example" do
    imp.build_fact(tuple, :great){|who| true}.should == true
  end

end