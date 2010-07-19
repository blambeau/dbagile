it "should return valid valid heading when table exists" do
  
  subject.heading(:basic_values).should == basic_values_heading
  
end
