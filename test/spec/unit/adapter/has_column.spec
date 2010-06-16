require File.expand_path('../../../spec_helper', __FILE__)
describe "::DbAgile::Adapter.has_column" do
  
  Fixtures::adapters_under_test.each do |adapter|
  
    describe "When called on an existing table but no such column" do
      subject{ adapter.has_column?(:dbagile, :no_such_column) }
      it{ should be_false }
    end
  
    describe "When called on an existing table and existing column" do
      subject{ adapter.has_column?(:dbagile, :version) }
      it{ should be_true }
    end
  
  end
  
end