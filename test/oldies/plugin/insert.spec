require File.expand_path('../../../spec_helper', __FILE__)
describe "::DbAgile::Plugin#insert" do
  
  let(:adapter){ Fixtures::sqlite_testdb_sequel_adapter }
  before{ adapter.create_table(nil, :table_name, :id => Integer, :name => String)}
  
  describe "when call on last brick" do
    let(:brick){ DbAgile::Core::Chain[DbAgile::Plugin.new, adapter] }
    specify {
      brick.insert(nil, :table_name, :id => 1, :name => "dbagile")
      adapter.dataset(:table_name).to_a.should == [{:id => 1, :name => "dbagile"}]
    }
  end
  
  describe "when call on non-last brick" do
    let(:brick){ DbAgile::Core::Chain[DbAgile::Plugin.new, DbAgile::Plugin.new, adapter] }
    specify {
      brick.insert(nil, :table_name, :id => 1, :name => "dbagile")
      adapter.dataset(:table_name).to_a.should == [{:id => 1, :name => "dbagile"}]
    }
  end

end