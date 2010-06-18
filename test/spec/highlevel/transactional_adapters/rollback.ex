it "should support rollbacking transactions explicitely without raising any error" do

  # Create the schema
  conn.transaction do |t|
    t.create_table(:example, :id => Integer)
    t.key!(:example, [ :id ])
  end

  # Make some insertions
  begin
    conn.transaction do |t|
      t.insert(:example, {:id => 1})
      t.dataset(:example).to_a.should == [{ :id => 1 }]
      t.rollback
      "No code executed after rollback".should be_nil
    end
  rescue Exception => ex
    "No exception raised".should be_nil
  end
  conn.dataset(:example).to_a.should == [ ]

end
