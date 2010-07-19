# .csv
describe "when called with .csv extension" do
  
  it "should return a text/csv string" do
    get("basic_values", '.csv'){|res,http|
      res.content_type.should == 'text/csv'
      res.body.should =~ /Standard values/
    }
  end
  
end # .csv

