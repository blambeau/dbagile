require File.expand_path('../../../fixtures', __FILE__)
describe "::DbAgile::Tools::Tuple#tuple_heading" do
  
  let(:tools){ Object.new.extend(DbAgile::Tools::Tuple) }
  
  describe "When called on on a typical tuple" do
    subject{ tools.tuple_heading(:id => 1, :name => "dbagile") }
    it{ should == {:id => Fixnum, :name => String} }
  end

end