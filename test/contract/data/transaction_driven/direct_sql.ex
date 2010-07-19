it "should support SELECT queries" do
  
  got = subject.direct_sql("SELECT * FROM basic_values")

  got.should be_kind_of(DbAgile::Contract::Data::Dataset)
  
  got.to_a.should == basic_values
  
end

it "should be smart enough" do

  subject.direct_sql("SELECT * FROM basic_values").should be_kind_of(DbAgile::Contract::Data::Dataset)

  subject.direct_sql("select * from basic_values").should be_kind_of(DbAgile::Contract::Data::Dataset)

  subject.direct_sql("   select * from basic_values where id=1").should be_kind_of(DbAgile::Contract::Data::Dataset)

end