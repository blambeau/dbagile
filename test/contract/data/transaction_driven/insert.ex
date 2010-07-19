it "should support inserting valid tuples" do
  
  subject.insert(:empty_table, :id => 1).should == {:id => 1}
  
  subject.dataset(:empty_table).count.should == 1
  
end

it "should raise a NoSuchTableError when table does not exists" do
  
  lambda { subject.insert(:unexisting, :id => 1) }.should raise_error(DbAgile::NoSuchTableError)
  
end

