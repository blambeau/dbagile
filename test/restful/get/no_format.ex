# no format
describe "when no extension is provided" do
  
  it "should return a valid JSON string" do
    get("basic_values"){|res,http|
      res.content_type.should == 'application/json'
      res.body.should be_a_valid_json_string
    }
  end
  
end # no format

