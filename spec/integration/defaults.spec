require File.expand_path("../../spec_helper", __FILE__)

Fixtures::adapters_under_test.each do |adapter|
  $id = 0
  db = FlexiDB.connect(adapter) do
    use FlexibleTable, :create_table => true 
    use Defaults,      :id   => lambda{ $id += 1 },
                       :name => "flexidb"
  end
  db.insert(:example, {})
  db.insert(:example, {})
  db.dataset(:example).to_a.should == [
    {:id => 1, :name => "flexidb"}, 
    {:id => 2, :name => "flexidb"}
  ]
end
