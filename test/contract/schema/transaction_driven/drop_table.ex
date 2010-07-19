it "should allow removing tables that exist" do
  
  subject.has_table?(:existing).should be_true
  
  subject.drop_table(:existing).should be_true
  
  subject.has_table?(:existing).should be_false
  
end

it "should raise a NoSuchTableError if the table does not exist" do
  
  subject.has_table?(:unexisting).should be_false

  lambda{ subject.drop_table(:unexisting) }.should raise_error(DbAgile::NoSuchTableError)
  
end