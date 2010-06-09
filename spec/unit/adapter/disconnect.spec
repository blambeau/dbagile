require File.expand_path('../../../spec_helper', __FILE__)
describe "::FlexiDB::Adapter.has_table" do
  
  Fixtures::adapters_under_test.each do |adapter|
    subject{ adapter.disconnect }
    it{ should be_true }
  end

end