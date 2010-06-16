require File.expand_path('../../../../spec_helper', __FILE__)
describe "::DbAgile::Adapter::Tools#tuple_project" do
  
  let(:tools){ Object.new.extend(DbAgile::Adapter::Tools) }
  let(:tuple){ {:id => 1, :name => "dbagile"} }
  
  describe "When called on on a typical tuple" do
    subject{ tools.tuple_project(tuple, [:id]) }
    it{ should == {:id => 1} }
  end
  
  describe "When called on on a typical tuple" do
    subject{ tools.tuple_project(tuple, [:id, :name]) }
    it{ should == {:id => 1, :name => "dbagile"} }
  end

  describe "When called on on a typical tuple" do
    subject{ tools.tuple_project(tuple, [:noone]) }
    it{ should == {:noone => nil} }
  end

  
end