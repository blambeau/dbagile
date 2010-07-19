it "should return a Contract::Data::Dataset instance" do

  subject.dataset(:basic_values).should be_kind_of(DbAgile::Contract::Data::Dataset)

end

it "should support SQL queries" do
  
  subject.dataset("SELECT * FROM basic_values").should be_kind_of(DbAgile::Contract::Data::Dataset)
  
end

it "should support a projection tuple" do
  
  subject.dataset(:basic_values, :id => 1).count.should == 1

  subject.dataset(:basic_values, :id => 10).count.should == 0
  
end

it "should support an empty projection tuple" do
  
  subject.dataset(:basic_values, {}).count.should == 1

end

it "should support a nil projection tuple" do
  
  subject.dataset(:basic_values, nil).count.should == 1

end
