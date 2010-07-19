# .json
describe "when called with .json extension" do
  
  it "should return a valid JSON string" do
    get("basic_values", '.json'){|res,http|
      res.content_type.should == 'application/json'
      res.body.should be_a_valid_json_string
    }
  end
  
end # .json

