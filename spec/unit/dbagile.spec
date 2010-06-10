require File.expand_path('../../spec_helper', __FILE__)
describe DbAgile do
  
  it 'should support a VERSION number' do
    DbAgile::VERSION.should be_kind_of(String)
  end
  
end