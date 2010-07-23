shared_examples_for("The schema:heading command") do
  
  it "should return the heading" do
    dba.schema_heading(%w{basic_values}).should == DbAgile::Fixtures::basic_values_heading
  end

end