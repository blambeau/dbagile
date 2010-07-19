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

