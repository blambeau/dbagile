require File.expand_path('../../../spec_helper', __FILE__)
describe "::DbAgile::Adapter#exists?" do
  
  Fixtures::adapters_under_test.each do |adapter|
  
    describe "When called on existing tuples" do
      before{ 
        adapter.create_table(nil,:example, {:id => Integer}) 
        adapter.insert(nil,:example, {:id => 1})
      }
      subject{ adapter.exists?(:example, {:id => 1}) }
      it{ should be_true }
    end
      
    describe "When called on non existing tuples" do
      before{ 
        adapter.create_table(nil,:example2, {:id => Integer}) 
        adapter.insert(nil,:example2, {:id => 1})
      }
      subject{ adapter.exists?(:example2, {:id => 2}) }
      it{ should be_false }
    end
      
    describe "When called with an emtpy projection on a non-empty table" do
      before{ 
        adapter.create_table(nil,:example3, {:id => Integer}) 
        adapter.insert(nil,:example3, {:id => 1})
      }
      subject{ adapter.exists?(:example3, {}) }
      it{ should be_true }
    end
      
    describe "When called with an emtpy projection on an empty table" do
      before{ 
        adapter.create_table(nil,:example4, {:id => Integer}) 
      }
      subject{ adapter.exists?(:example4, {}) }
      it{ should be_false }
    end
      
  end
  
end