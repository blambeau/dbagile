require File.expand_path('../../../../spec_helper', __FILE__)
describe "::FlexiDB::Plugin::Defaults#compute_defaults" do
  
  before{ ::FlexiDB::Plugin::Defaults.instance_eval{public :compute_defaults} }
  let(:defaults){ ::FlexiDB::Plugin::Defaults.new(nil, nil) }
  
  describe "When called with constant values" do
    subject{ defaults.compute_defaults(nil, :name => "flexidb", :version => FlexiDB::VERSION) }
    it { should == {:name => "flexidb", :version => FlexiDB::VERSION} }
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