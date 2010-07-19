it "should support updating all tuples" do
  
  subject.update(:non_empty_table, :english => "None")
  
  expected = [{:id => 1, :english => "None"}, {:id => 2, :english => "None"}]

  subject.dataset(:non_empty_table).to_a.sort{|t1,t2| t1[:id] <=> t2[:id]}.should == expected
  
end

it "should support updating some tuples only" do
  
  subject.update(:non_empty_table, {:english => "None"}, {:id => 1})
  
  expected = [{:id => 1, :english => "None"}, {:id => 2, :english => "Two"}]

  subject.dataset(:non_empty_table).to_a.sort{|t1,t2| t1[:id] <=> t2[:id]}.should == expected
  
end

it "should raise a NoSuchTableError when table does not exists" do
  
  lambda { subject.update(:unexisting, :id => 1) }.should raise_error(DbAgile::NoSuchTableError)
  
end
