it "should support inserting valid tuples" do
  
  subject.insert(:empty_table, :id => 1).should == {:id => 1}
  
  subject.dataset(:empty_table).count.should == 1
  
end

