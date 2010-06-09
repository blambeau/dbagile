require File.expand_path('../../../spec_helper', __FILE__)
describe "::FlexiDB::Plugin#tuple_heading" do
  
  let(:plugin){ FlexiDB::Plugin.new(nil) }
  
  describe "When called on on a typical tuple" do
    subject{ plugin.send(:tuple_heading, :id => 1, :name => "flexidb") }
    it{ should == {:id => Fixnum, :name => String} }
  end

  describe "When called with nil values" do
    subject{ plugin.send(:tuple_heading, :id => 1, :name => nil) }
    it{ should == {:id => Fixnum} }
  end

  
end