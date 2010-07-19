# .txt
describe "when called with .txt extension" do
  
  it "should return a text string" do
    get("basic_values", '.txt'){|res,http|
      res.content_type.should == 'text/plain'
      res.body.should =~ /Standard values/
    }
  end
  
end # .csv

