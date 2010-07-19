it "should allow creating tables if the don't exist" do
  
  subject.has_table?(:unexisting).should be_false
  
  subject.create_table(:unexisting, :id => Integer).should == {:id => Integer}
  
  subject.has_table?(:unexisting).should be_true
  
end

it "should raise a TableAlreadyExistsError if name is already in use" do
  
  subject.has_table?(:basic_values).should be_true

  lambda{ subject.create_table(:basic_values, :id => Integer) }.should raise_error(DbAgile::TableAlreadyExistsError)
  
end