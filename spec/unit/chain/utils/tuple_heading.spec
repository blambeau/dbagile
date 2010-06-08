require File.expand_path('../../../../spec_helper', __FILE__)
describe "::FlexiDB::Chain::Utils#tuple_heading" do
  
  let(:utils){ Object.new.extend(FlexiDB::Chain::Utils) }
  
  describe "When called on on a typical tuple" do
    subject{ utils.tuple_heading(:id => 1, :name => "flexidb") }
    it{ should == {:id => Fixnum, :name => String} }
  end

  describe "When called with nil values" do
    subject{ utils.tuple_heading(:id => 1, :name => nil) }
    it{ should == {:id => Fixnum} }
  end

  
end