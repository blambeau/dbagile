# no format
describe "when no extension is provided" do
  
  it "should return a valid JSON string" do
    client.post(basic_values_uri, {:id => 2, :name => "This is a second test"}){|res,http|
      res.content_type.should == 'application/json'
      res.body.should be_a_valid_json_string
      res.body.should =~ /This is a second test/
    }
    
    # tuple should be inserted
    client.get(basic_values_uri('.json'), {:id => 2}){|res,http|
      res.body.should =~ /This is a second test/
    }
    
    # other tuples should not been touched
    client.get(basic_values_uri('.json')){|res,http|
      res.body.should =~ /Standard values/
    }
  end
  
end