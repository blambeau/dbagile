shared_examples_for("The sql:show command") do
  
  it "should return the output buffer" do
    dba.sql_show(%w{suppliers}).should == dba.output_buffer
  end
  
  it "should print the table one the output buffer" do
    dba.sql_show(%w{suppliers})
    dba.output_buffer.string.should =~ /^\+\-/
  end
  
  it "should support pretty-printing" do
    dba.sql_show(%w{--pretty suppliers})
    dba.output_buffer.string.should =~ /\.\.\.$/
  end
  
end
