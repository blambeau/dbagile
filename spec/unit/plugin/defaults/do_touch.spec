require File.expand_path('../../../../spec_helper', __FILE__)
describe "::DbAgile::Plugin::Defaults#__do_touch" do
  
  before{ ::DbAgile::Plugin::Defaults.instance_eval{public :__do_touch} }
  let(:defaults){ ::DbAgile::Plugin::Defaults.new(nil, nil) }
  
  describe "When called with constant values" do
    subject{ defaults.__do_touch({}, :name => "dbagile", :version => DbAgile::VERSION) }
    it { should == {:name => "dbagile", :version => DbAgile::VERSION} }
  end
  
  describe "When called with nil" do
    subject{ defaults.__do_touch({}, :name => nil) }
    it { should == {} }
  end
  
  describe "When called with a proc" do
    let(:proc){ lambda{ "hello world" }}
    subject{ defaults.__do_touch({}, :name => proc) }
    it { should == {:name => "hello world"} }
  end
  
  describe "When called with a proc taing tuple as parameter" do
    let(:proc){ lambda{|tuple| tuple[:name]*2 }}
    subject{ defaults.__do_touch({:name => "dbagile"}, :saytwice => proc) }
    it { should == {:saytwice => "dbagiledbagile", :name => "dbagile"} }
  end
  
end