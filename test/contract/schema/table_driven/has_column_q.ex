it "should return true on exising column" do
  
  subject.has_column?(:basic_values, :id).should be_true
  
end

it "should return true on unexising column" do
  
  subject.has_column?(:basic_values, :unexisting).should be_false
  
end


