it "should allow creating tables if the don't exist" do
  
  subject.has_table?(:unexisting).should be_false
  
  subject.create_table(:unexisting, :id => Integer).should == {:id => Integer}
  
  subject.has_table?(:unexisting).should be_true
  
end

