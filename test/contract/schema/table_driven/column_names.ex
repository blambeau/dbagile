it "should return valid columns when table exists" do
  
  subject.column_names(:basic_values, true).should == basic_values_keys
  
end

it "should raise a NoSuchTableError when table does not exists" do
  
  lambda { subject.column_names(:unexisting) }.should raise_error(DbAgile::NoSuchTableError)
  
end
