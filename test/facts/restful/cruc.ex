specify("reading from unknown facts") do
  lambda{ RestClient.get("#{resturi}/people") }.should raise_error(RestClient::ResourceNotFound)
end

specify "posting a fact by providing a key" do
  res = RestClient.post("#{resturi}/people", {:'#' => 1, :name => "blambeau"}.to_json, :content_type => :json, :accept => :json)
  res.code.should == 200
  ::Facts::Restful::json_decode(res.body)[:'#'].should == 1
  
  res = RestClient.get("#{resturi}/people/1")
  res.code.should == 200
  ::Facts::Restful::json_decode(res.body)[:name].should == "blambeau"
end