require File.expand_path('../../../spec_helper', __FILE__)
describe "::DbAgile::Adapter.has_column" do
  
  Fixtures::adapters_under_test.each do |adapter|
  
    describe "When called on non existing table" do
      subject{ lambda{ adapter.column_names(:no_such_table) } }
      it{ should raise_error(ArgumentError) }
    end
  
    describe "When called with sorting option" do
      subject{ adapter.column_names(:dbagile, true) }
      it{ should == [:id, :schema, :version] }
    end
  
  end
  
end