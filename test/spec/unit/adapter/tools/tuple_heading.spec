require File.expand_path('../../../../spec_helper', __FILE__)
describe "::DbAgile::Adapter::Tools#tuple_heading" do
  
  let(:tools){ Object.new.extend(DbAgile::Adapter::Tools) }
  
  describe "When called on on a typical tuple" do
    subject{ tools.tuple_heading(:id => 1, :name => "dbagile") }
    it{ should == {:id => Fixnum, :name => String} }
  end

  describe "When called with nil values" do
    subject{ tools.tuple_heading(:id => 1, :name => nil) }
    it{ should == {:id => Fixnum} }
  end

  
end