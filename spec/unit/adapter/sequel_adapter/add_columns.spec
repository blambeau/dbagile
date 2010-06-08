require File.expand_path('../../../../spec_helper', __FILE__)
describe "::FlexiDB::Adapter.add_columns" do
  
  let(:adapter){ Fixtures::sqlite_testdb_sequel_adapter }
  
  describe "When called on a non existing table" do
    subject{ lambda{ adapter.add_columns(:no_such_table, {:id => Integer}) } }
    it{ should raise_error(ArgumentError) }
  end

  describe "When called on an existing table" do
    subject{ adapter.add_columns(:flexidb, {:id => Integer, :name => String}) }
    specify{ 
      subject.should be_true
      adapter.column_names(:flexidb, true).should == [:id, :name, :schema, :version]
    }
  end
  
end