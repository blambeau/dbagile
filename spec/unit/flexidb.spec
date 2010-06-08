require File.expand_path('../../spec_helper', __FILE__)
describe FlexiDB do
  
  it 'should support a VERSION number' do
    FlexiDB::VERSION.should be_kind_of(String)
  end
  
end