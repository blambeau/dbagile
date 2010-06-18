it "should support transaction schema updates" do

  # Make some insertions
  begin
    conn.transaction do |t|
      t.create_table(:example, :id => Integer)
      t.rollback
      "No code executed after rollback".should be_nil
    end
    conn.has_table?(:example).should be_false
  rescue Exception => ex
    "No exception raised".should be_nil
  end

end
