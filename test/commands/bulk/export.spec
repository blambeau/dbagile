shared_examples_for("The bulk:export command") do
  
  it "should return the output buffer" do
    dba.bulk_export(%w{suppliers}).should == dba.output_buffer
  end

  it "should support a --select option" do
    dba.bulk_export(%w{--csv --select id,name basic_values})
    dba.output_buffer.string.should =~ /^1,Standard values/
  end
  
  it "should support a --allbut option" do
    dba.bulk_export(%w{--csv --allbut name basic_values})
    dba.output_buffer.string.should_not =~ /Standard values/
  end
  
  ### --csv
  
  describe "When used with --csv option" do
    
    it "should support a --headers option" do
      dba.bulk_export(%w{--csv --headers --select id,name basic_values})
      dba.output_buffer.string.should =~ /^id,name/
    end
  
    it "should support a --seperator option" do
      dba.bulk_export(%w{--csv --separator=; --select id,name basic_values})
      dba.output_buffer.string.should =~ /^1;Standard values/
    end
  
    it "should support --force-quotes --quote options" do
      dba.bulk_export(%w{--csv --quote=' --force-quotes --select id,name basic_values})
      dba.output_buffer.string.strip.should == "'1','Standard values'"
    end
    
  end
  
  ### --json
  
  describe "When used with --json option" do
    
    it "should return a valid JSON string" do
      result = dba.bulk_export(%w{--json basic_values}).string
      result.should be_a_valid_json_string
      back_tuple = JSON::parse(result)[0]
      DbAgile::Fixtures::basic_values[0].each_pair{|k,v| 
        next if v.kind_of?(Time) or v.kind_of?(Date) # not supported by json
        back_tuple[k.to_s].should == v
      }
    end
    
    it "should support a --no-pretty option" do
      result = dba.bulk_export(%w{--json --no-pretty --select id,name basic_values}).string
      result.strip.should_not =~ /\n/
      result.should be_a_valid_json_string
    end

    it "should support a --pretty option" do
      result = dba.bulk_export(%w{--json --pretty --select id,name basic_values}).string
      result.strip.should =~ /\n/
      result.should be_a_valid_json_string
    end

    it "should support a --type-sage option" do
      result = dba.bulk_export(%w{--json --type-safe basic_values}).string
      result.should be_a_valid_json_string
    end
    
  end
  
  ### --yaml

  describe "When used with --yaml option" do

    it "should return yaml valid string" do
      result = dba.bulk_export(%w{--yaml basic_values}).string
      result.should be_a_valid_yaml_string
      YAML::load(result).should == DbAgile::Fixtures::basic_values
    end
    
    it "should return yaml valid string with --type-safe" do
      result = dba.bulk_export(%w{--yaml --type-safe basic_values}).string
      result.should be_a_valid_yaml_string
    end
    
  end

  ### --ruby
  
  describe "When used with --ruby option" do
    
    it "should support a valid ruby string" do
      dba.bulk_export %w{--ruby basic_values}
      back = Kernel.eval(dba.output_buffer.string)
      back.should == DbAgile::Fixtures::basic_values
    end
    
  end
  
end
