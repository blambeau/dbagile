# no format
describe "when a .txt extension is provided" do
  
  it "should return a valid JSON string" do
    client.post(basic_values_uri('.txt'), {:id => 2}){|res,http|
      res.content_type.should == 'text/plain'
      res.body.should =~ /[+][-]/
    }
  end
  
end