require File.expand_path("../../spec_helper", __FILE__)

db = FlexiDB.connect(Fixtures::sqlite_testdb_sequel_adapter) do
  use FlexiDB::Chain::FlexibleTable, :create_table => true 
end
db.insert(:example, :id => 1)
db.insert(:example, :name => "blambeau")
db.dataset(:example).to_a.should == [{:id => 1, :name => nil}, {:id => nil, :name => "blambeau"}]

