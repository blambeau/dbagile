it "should return valid columns when table exists" do
  
  subject.column_names(:basic_values, true).should == basic_values_keys
  
end
