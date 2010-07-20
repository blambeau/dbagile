shared_examples_for("The heading command") do
  
  it "should return the heading" do
    dba.heading(%w{basic_values}).should == DbAgile::Fixtures::basic_values_heading
  end

end