require File.expand_path('../../../spec_helper', __FILE__)
describe "::FlexiDB::Adapter.has_table" do
  
  Fixtures::adapters_under_test.each do |adapter|
  
    describe "When called on existing table" do
      before{ adapter.create_table(:example, :id => Integer) }
      subject{ adapter.insert(:example, :id => 12) }
      specify{ 
        subject.should == {:id => 12} 
      }
    end
  
  end
  
end