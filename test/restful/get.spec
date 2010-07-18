shared_examples_for("The Restful GET interface") do
  
  # .txt
  describe "when called with .txt extension" do
    
    it "should return a text string" do
      get("basic_values", '.txt'){|res,http|
        res.content_type.should == 'text/plain'
        res.body.should =~ /Standard values/
      }
    end
    
  end # .csv
  
  # .csv
  describe "when called with .csv extension" do
    
    it "should return a text/csv string" do
      get("basic_values", '.csv'){|res,http|
        res.content_type.should == 'text/csv'
        res.body.should =~ /Standard values/
      }
    end
    
  end # .csv
  
  # .json
  describe "when called with .json extension" do
    
    it "should return a valid JSON string" do
      get("basic_values", '.json'){|res,http|
        res.content_type.should == 'application/json'
        res.body.should be_a_valid_json_string
      }
    end
    
  end # .json
  
  # .yaml
  [".yaml", ".yml"].each do |ext|
    describe "when called with #{ext} extension" do
    
      it "should return a valid YAML string" do
        get("basic_values", ext){|res,http|
          res.content_type.should == 'text/yaml'
          res.body.should be_a_valid_yaml_string
        }
      end
    
    end
  end  # .yaml
  
end