shared_examples_for("The show command") do
  
  it "should return the output buffer" do
    DbAgile::command(environment) do |env, api|
      api.use(%w{sqlite})
      api.show(%w{suppliers}).should == env.output_buffer
    end
  end
  
  it "should print the table one the output buffer" do
    DbAgile::command(environment) do |env, api|
      api.use(%w{sqlite})
      api.show(%w{suppliers})
      env.output_buffer[-2].should =~ /^\+\-/
    end
  end
  
end
