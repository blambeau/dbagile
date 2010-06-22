it "should support creating SQL databases the standard way" do

  # Create the schema
  conn.transaction do |t|
    t.create_table(:example, :id => Integer, :name => String)
    t.key!(:example, [ :id ])
  end

  # Some checks
  conn.has_table?(:example).should be_true
  conn.is_key?(:example, [ :id ]).should be_true

  # Make some insertions
  conn.transaction do |t|
    t.insert(:example, {:id => 1, :name => "dbagile"})
    t.dataset(:example).to_a.should == [{ :id => 1, :name => "dbagile" }]
  end
  conn.dataset(:example).to_a.should == [{ :id => 1, :name => "dbagile" }]
  
end
