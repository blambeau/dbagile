require File.expand_path('../../../spec_helper', __FILE__)
describe "::DbAgile::Adapter.has_table" do
  
  Fixtures::adapters_under_test.each do |adapter|
  
    describe "When called on existing tuple with #{adapter.class}" do
      before{  
        adapter.create_table(:example, :id => Integer, :name => "dbagile") 
        adapter.insert(:example, :id => 1, :name => "dbagile")
        adapter.insert(:example, :id => 2, :name => "sequel")
      }
      subject{ 
        adapter.update(:example, {:id => 1}, :name => "DbAgile") 
      }
      specify{ 
        subject.should be_true
        adapter.dataset(:example).to_a.should == [
          {:id => 1, :name => "DbAgile"},
          {:id => 2, :name => "sequel"}
        ] 
      }
    end
  
  end
  
end