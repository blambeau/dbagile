require File.expand_path('../../../spec_helper', __FILE__)
describe "DbAgile's API" do
  
  it "should support creating configurations" do
    db = DbAgile::config(:example){
      (uri "memory://example.db")
      (plug AgileKeys, AgileTable)
      (plug Defaults, :hello => "world")
    }
    db.should be_kind_of(DbAgile::Core::Configuration)
  end
  
  it "should support reusing previous configurations" do
    DbAgile::config(:example){
      (uri "memory://example.db")
      (plug AgileKeys, AgileTable)
      (plug Defaults, :hello => "world")
    }
    DbAgile::config(:example).should be_kind_of(DbAgile::Core::Configuration)
    DbAgile::config(:example).uri.should == "memory://example.db"
  end
  
end