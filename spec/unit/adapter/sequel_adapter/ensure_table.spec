require File.expand_path('../../../../spec_helper', __FILE__)
describe "::FlexiDB::Adapter.ensure_table" do
  
  let(:adapter){ Fixtures::sqlite_testdb_sequel_adapter }
  
  describe "When called on non existing table" do
    subject{ adapter.ensure_table(:example, :id => Integer, :name => String) }
    specify {
      subject.should be_true
      adapter.has_table?(:example).should be_true
      adapter.column_names(:example, true).should == [:id, :name]
    }
  end

  describe "When called on an existing table with all columns already defined" do
    before{ adapter.create_table(:example, :id  => Integer, :name => String) }
    subject{ adapter.ensure_table(:example, :id => Integer, :name => String) }
    specify {
      subject.should be_true
      adapter.has_table?(:example).should be_true
      adapter.column_names(:example, true).should == [:id, :name]
    }
  end
  
  describe "When called on an existing table with no columns already defined" do
    before{ adapter.create_table(:example, :id  => Integer) }
    subject{ adapter.ensure_table(:example, :id2 => Integer, :name => String) }
    specify {
      subject.should be_true
      adapter.has_table?(:example).should be_true
      adapter.column_names(:example, true).should == [:id, :id2, :name]
    }
  end
  
  describe "When called on an existing table with some columns already defined" do
    before{ adapter.create_table(:example, :id  => Integer) }
    subject{ adapter.ensure_table(:example, :id => Integer, :name => String) }
    specify {
      subject.should be_true
      adapter.has_table?(:example).should be_true
      adapter.column_names(:example, true).should == [:id, :name]
    }
  end
  
end