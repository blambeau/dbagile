it "should return true on existing tables" do
  
  subject.has_table?(:basic_values).should be_true
  
end

it "should return false on unexisting tables" do
  
  subject.has_table?(:unexisting).should be_false
  
end