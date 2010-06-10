require File.expand_path('../../../../spec_helper', __FILE__)
describe "::DbAgile::Plugin::Defaults#compute_defaults" do
  
  before{ ::DbAgile::Plugin::Defaults.instance_eval{public :compute_defaults} }
  let(:defaults){ ::DbAgile::Plugin::Defaults.new(nil, nil) }
  
  describe "When called with constant values" do
    subject{ defaults.compute_defaults(nil, :name => "flexidb", :version => DbAgile::VERSION) }
    it { should == {:name => "flexidb", :version => DbAgile::VERSION} }
  end
  
  describe "When called with nil" do
    subject{ defaults.compute_defaults(nil, :name => nil) }
    it { should == {} }
  end
  
  describe "When called with a proc" do
    let(:proc){ lambda{ "hello world" }}
    subject{ defaults.compute_defaults(nil, :name => proc) }
    it { should == {:name => "hello world"} }
  end
  
  describe "When called with a proc taing tuple as parameter" do
    let(:proc){ lambda{|tuple| tuple[:name]*2 }}
    subject{ defaults.compute_defaults({:name => "flexidb"}, :saytwice => proc) }
    it { should == {:saytwice => "flexidbflexidb"} }
  end
  
end