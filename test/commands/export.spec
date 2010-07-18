shared_examples_for("The export command") do
  
  it "should return the output buffer" do
    dba.export(%w{suppliers}).should == dba.output_buffer
  end

  it "should support a --select option" do
    dba.export(%w{--csv --select id,name basic_values})
    dba.output_buffer.string.should =~ /^1,Standard values/
  end
  
  it "should support a --allbut option" do
    dba.export(%w{--csv --allbut name basic_values})
    dba.output_buffer.string.should_not =~ /Standard values/
  end
  
  ### --csv
  
  describe "When used with --csv option" do
    
    it "should support a --headers option" do
      dba.export(%w{--csv --headers --select id,name basic_values})
      dba.output_buffer.string.should =~ /^id,name/
    end
  
    it "should support a --seperator option" do
      dba.export(%w{--csv --separator=; --select id,name basic_values})
      dba.output_buffer.string.should =~ /^1;Standard values/
    end
  
    it "should support --force-quotes --quote options" do
      dba.export(%w{--csv --quote=' --force-quotes --select id,name basic_values})
      dba.output_buffer.string.strip.should == "'1','Standard values'"
    end
    
  end
  
  ### --json
  
  describe "When used with --json option" do
    
    it "should return a valid JSON string" do
      dba.export %w{--json basic_values}
      back_tuple = JSON::parse(dba.output_buffer.string)[0]
      DbAgile::Fixtures::basic_values[0].each_pair{|k,v| 
        next if v.kind_of?(Time) or v.kind_of?(Date) # not supported by json
        back_tuple[k.to_s].should == v
      }
    end
    
    it "should support a --no-pretty option" do
      dba.export %w{--json --no-pretty --select id,name basic_values}
      dba.output_buffer.string.strip.should_not =~ /\n/
    end

    it "should support a --pretty option" do
      dba.export %w{--json --pretty --select id,name basic_values}
      dba.output_buffer.string.strip.should =~ /\n/
    end
    
  end
  
  ### --yaml

  describe "When used with --yaml option" do

    it "should return yaml valid string" do
      dba.export %w{--yaml basic_values}
      back = YAML::load(dba.output_buffer.string)
      back.should == DbAgile::Fixtures::basic_values
    end
    
  end

  ### --ruby
  
  describe "When used with --ruby option" do
    
    it "should support a valid ruby string" do
      dba.export %w{--ruby basic_values}
      back = Kernel.eval(dba.output_buffer.string)
      back.should == DbAgile::Fixtures::basic_values
    end
    
  end
  
end
