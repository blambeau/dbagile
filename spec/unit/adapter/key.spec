require File.expand_path('../../../spec_helper', __FILE__)
describe "::DbAgile::Adapter.key" do
  
  Fixtures::adapters_under_test.each do |adapter|
  
    describe "When called composite" do
      before(:all){ adapter.create_table(nil, :example, :id => Integer, :name => String) }
      subject{ adapter.key!(nil, :example, [:id, :name]) }
      specify{ 
        subject.should be_true
        adapter.insert(nil, :example, :id => 1, :name => "dbagile")
        lambda{ adapter.insert(nil, :example, :id => 1, :name => "other") }.should_not raise_error
        lambda{ adapter.insert(nil, :example, :id => 1, :name => "dbagile") }.should raise_error
      }
    end
  
  end
  
end