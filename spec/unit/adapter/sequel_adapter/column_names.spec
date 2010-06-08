require File.expand_path('../../../../spec_helper', __FILE__)
describe "::FlexiDB::Adapter.has_column" do
  
  let(:adapter){ Fixtures::sqlite_testdb_sequel_adapter }
  
  describe "When called on non existing table" do
    subject{ lambda{ adapter.column_names(:no_such_table) } }
    it{ should raise_error(ArgumentError) }
  end
  
  describe "When called on an existing table" do
    subject{ adapter.column_names(:flexidb) }
    it{ should == [:version, :schema] }
  end
  
  describe "When called with sorting option" do
    subject{ adapter.column_names(:flexidb, true) }
    it{ should == [:schema, :version] }
  end
  
end