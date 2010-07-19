it "should returns expected columns" do
  
  subject.columns.sort{|a,b| a.to_s <=> b.to_s}.should == basic_values_keys
  
end