require File.expand_path('../../../spec_helper', __FILE__)
describe "::FlexiDB::Adapter.dataset" do
  
  Fixtures::adapters_under_test.each do |adapter|
  
    describe "When called on non existing table" do
      subject{ lambda{ adapter.dataset(:no_such_table) } }
      it{ should raise_error(ArgumentError) }
    end
  
    describe "When called on an existing table" do
      subject{ adapter.dataset(:flexidb) }
      it{ should be_kind_of(Enumerable) }
    end
  
  end
  
end