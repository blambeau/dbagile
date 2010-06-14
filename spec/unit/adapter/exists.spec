require File.expand_path('../../../spec_helper', __FILE__)
describe "::DbAgile::Adapter#exists?" do
  
  Fixtures::adapters_under_test.each do |adapter|
  
    describe "When called on existing tuples" do
      before{ 
        adapter.create_table(:example, {:id => Integer}) 
        adapter.insert(:example, {:id => 1})
      }
      subject{ adapter.exists?(:example, {:id => 1}) }
      it{ should be_true }
    end
      
    describe "When called on non existing tuples" do
      before{ 
        adapter.create_table(:example2, {:id => Integer}) 
        adapter.insert(:example2, {:id => 1})
      }
      subject{ adapter.exists?(:example2, {:id => 2}) }
      it{ should be_false }
    end
      
  end
  
end