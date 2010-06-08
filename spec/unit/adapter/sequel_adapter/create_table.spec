require File.expand_path('../../../../spec_helper', __FILE__)
describe "::FlexiDB::Adapter.create_table" do
  
  let(:adapter){ Fixtures::sqlite_testdb_sequel_adapter }
  
  describe "When called on an existing table" do
    subject{ lambda{ adapter.create_table(:flexidb, {:id => Integer}) } }
    it{ should raise_error(ArgumentError) }
  end

  describe "When called on an unexisting table" do
    subject{ adapter.create_table(:example, {:id => Integer, :name => String}) }
    specify{ 
      subject.should be_true
      adapter.has_table?(:example).should be_true
      adapter.column_names(:example, true).should == [:id, :name]
    }
  end
  
end