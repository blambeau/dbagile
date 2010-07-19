require File.expand_path('../../../spec_helper', __FILE__)
describe "DbAgile's API" do
  
  before{
    DbAgile::config(:agile){
      uri  "sqlite:///tmp/dbagile_test.db"
      plug AgileKeys, AgileTable
    }
  }
  
  it "should support connecting to a named configuration" do
    DbAgile::connect(:agile).should be_kind_of(DbAgile::Core::Connection)
  end
  
  it "should support connecting directly to a sql database" do
    DbAgile::connect("sqlite:///tmp/dbagile_test.db").should be_kind_of(DbAgile::Core::Connection)
  end
  
  it "should raise an error when unknown configuration" do
    lambda{ DbAgile::connect(:no_such_one) }.should raise_error(DbAgile::NoSuchConfigError)
  end
  
end