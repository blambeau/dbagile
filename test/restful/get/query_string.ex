describe "it should support projection through the query string" do
  
  it "should correctly project the table" do
    get("basic_values", '.json', {:id => 0}){|res,http|
      res.body.should be_a_valid_json_string
      JSON::parse(res.body).size.should == 0
    }
  end
  
  
end