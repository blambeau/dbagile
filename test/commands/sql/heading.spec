shared_examples_for("The sql:heading command") do
  
  it "should return the heading" do
    dba.sql_heading(%w{basic_values}).should == DbAgile::Fixtures::basic_values_heading
  end

end