it "should return true on non empty result" do
  
  subject.exists?(:basic_values, :id => 1).should be_true
  
end

it "should return false on empty result" do
  
  subject.exists?(:basic_values, :id => 10).should be_false
  
end


it "should support SQL queries" do
  
  subject.exists?("SELECT * FROM basic_values").should be_true

  subject.exists?("SELECT * FROM basic_values WHERE id=10").should be_false
  
end

it "should support an empty projection" do
  
  subject.exists?(:basic_values, {}).should be_true
  subject.exists?(:empty_table, {}).should be_false
  
end