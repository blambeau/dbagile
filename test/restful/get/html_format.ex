# .html
describe "when called with .html extension" do
  
  it "should return an html string" do
    client.get(basic_values_uri('.html')){|res,http|
      res.content_type.should == 'text/html'
      res.body.should =~ /Standard values/
    }
  end
  
end # .html

