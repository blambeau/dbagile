require File.expand_path("../../spec_helper", __FILE__)

Fixtures::adapters_under_test.each do |adapter|
  db = DbAgile.connect(adapter) do
    use AgileTable, :create_table => true 
  end
  db.insert(:example, :id => 1)
  db.insert(:example, :name => "blambeau")
  db.dataset(:example).to_a.should == [{:id => 1, :name => nil}, {:id => nil, :name => "blambeau"}]
end
