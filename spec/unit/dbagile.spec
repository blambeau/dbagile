require File.expand_path('../../spec_helper', __FILE__)
describe DbAgile do
  
  it 'should support a VERSION number' do
    DbAgile::VERSION.should be_kind_of(String)
  end
  
  it "should support executing code directly" do
    DbAgile.execute{
      connect "sqlite://test.db"
    }.should be_kind_of(DbAgile::Database)
  end
  
  it "should support executing source directly" do
    DbAgile.execute('connect "sqlite://test.db"').should be_kind_of(DbAgile::Database)
  end
  
end