shared_examples_for("The export command") do
  
  it "should return the output buffer" do
    dba.export(%w{suppliers}).should == env.output_buffer
  end

  it "should support a --headers option" do
    dba.export(%w{--csv --headers --select id,name basic_values})
    env.output_buffer.string.should =~ /^id,name/
  end
  
  it "should support a --select option" do
    dba.export(%w{--csv --select id,name basic_values})
    env.output_buffer.string.should =~ /^1,Standard values/
  end
  
  it "should support a --allbut option" do
    dba.export(%w{--csv --allbut name basic_values})
    env.output_buffer.string.should_not =~ /Standard values/
  end
  
  it "should support a --csv --seperator option" do
    dba.export(%w{--csv --separator=; --select id,name basic_values})
    env.output_buffer.string.should =~ /^1;Standard values/
  end
  
  it "should support a --csv --quote option" do
    dba.export(%w{--csv --quote=' --force-quotes --select id,name basic_values})
    env.output_buffer.string.strip.should == "'1','Standard values'"
  end
  
  it "should support a --json option" do
    dba.export %w{--json --select id,name basic_values}
    back = JSON::parse(env.output_buffer.string)
    back.should == [{'id' => 1, 'name' => 'Standard values'}]
  end

  it "should support a --yaml option" do
    dba.export %w{--yaml --select id,name basic_values}
    back = YAML::load(env.output_buffer.string)
    back.should == [{:id => 1, :name => 'Standard values'}]
  end

  it "should support a --ruby option" do
    dba.export %w{--ruby --select id,name basic_values}
    back = Kernel.eval(env.output_buffer.string)
    back.should == [{:id => 1, :name => 'Standard values'}]
  end
  
end
