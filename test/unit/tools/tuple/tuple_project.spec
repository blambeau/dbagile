require File.expand_path('../../../fixtures', __FILE__)
describe "::DbAgile::Tools::Tuple#tuple_project" do
  
  let(:tools){ Object.new.extend(DbAgile::Tools::Tuple) }
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