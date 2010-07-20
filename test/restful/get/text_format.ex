# .txt
describe "when called with .txt extension" do
  
  it "should return a text string" do
    client.get(basic_values_uri('.txt')){|res,http|
      res.content_type.should == 'text/plain'
      res.body.should =~ /Standard values/
    }
  end
  
end # .csv

