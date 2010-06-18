it "should automatically rollback transaction on errors" do

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
      raise ArgumentError, "Not that good!"
    end
    true.should be_false
  rescue ArgumentError => ex
    ex.message.should == "Not that good!"
    conn.dataset(:example).to_a.should == [ ]
  end

end
