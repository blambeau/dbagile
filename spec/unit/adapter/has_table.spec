require File.expand_path('../../../spec_helper', __FILE__)
describe "::DbAgile::Adapter.has_table" do
  
  Fixtures::adapters_under_test.each do |adapter|
  
    describe "When called on non existing table" do
      subject{ adapter.has_table?(:no_such_table) }
      it{ should be_false }
    end
  
    describe "When called on existing table" do
      subject{ adapter.has_table?(:flexidb) }
      it{ should be_true }
    end

  end
  
end