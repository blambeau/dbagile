require File.expand_path('../../../fixtures', __FILE__)
describe "::DbAgile::Tools::Tuple#tuple_key" do
  
  let(:tools){ Object.new.extend(DbAgile::Tools::Tuple) }
  let(:tuple){ {:id => 1, :name => "dbagile", :version => DbAgile::VERSION} }
  
  describe "When called without keys info" do
    subject{ tools.tuple_key(tuple, nil) }
    it{ should == tuple }
  end
  
  describe "When called without matching key" do
    subject{ tools.tuple_key(tuple, [[:hello], [:world, [:again]]]) }
    it{ should == tuple }
  end
  
  describe "When called with a single matching key" do
    subject{ tools.tuple_key(tuple, [ [:id] ]) }
    it{ should == {:id => 1} }
  end
  
  describe "When called with a composite second matching key" do
    subject{ tools.tuple_key(tuple, [ [:id2], [:name, :version] ]) }
    it{ should == {:name => "dbagile", :version => DbAgile::VERSION} }
  end
  
end