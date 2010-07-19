it "should allow removing tables that exist" do
  
  subject.has_table?(:existing).should be_true
  
  subject.drop_table(:existing).should be_true
  
  subject.has_table?(:existing).should be_false
  
end

