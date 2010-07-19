it "should support deleting on empty tables" do
  
  subject.delete(:empty_table)
  
  subject.dataset(:empty_table).count.should == 0
  
end

it "should support deleting on non empty tables" do
  
  subject.dataset(:non_empty_table).count.should == 2
  
  subject.delete(:non_empty_table)
  
  subject.dataset(:non_empty_table).count.should == 0
  
end

it "should allow specifying a projection tuple" do
  
  subject.dataset(:non_empty_table).count.should == 2
  
  subject.delete(:non_empty_table, :id => 1)
  
  subject.dataset(:non_empty_table).to_a.should == [ {:id => 2, :english => "Two"} ]
  
end

it "should raise a NoSuchTableError when table does not exists" do
  
  lambda { subject.delete(:unexisting) }.should raise_error(DbAgile::NoSuchTableError)
  
end

