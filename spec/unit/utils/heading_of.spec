require File.expand_path('../../../spec_helper', __FILE__)
describe "::FlexiDB::Utils.heading_of" do
  
  let(:utils){ FlexiDB::Utils }
  
  describe "When called on on a typical tuple" do
    subject{ utils.heading_of(:id => 1, :name => "flexidb") }
    it{ should == {:id => Fixnum, :name => String} }
  end

  describe "When called with nil values" do
    subject{ utils.heading_of(:id => 1, :name => nil) }
    it{ should == {:id => Fixnum} }
  end

  
end