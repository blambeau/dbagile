it "should return true on exising column" do
  
  subject.has_column?(:basic_values, :id).should be_true
  
end

it "should return true on unexising column" do
  
  subject.has_column?(:basic_values, :unexisting).should be_false
  
end

it "should raise a NoSuchTableError when table does not exists" do
  
  lambda { subject.has_column?(:unexisting, :id) }.should raise_error(DbAgile::NoSuchTableError)
  
end

