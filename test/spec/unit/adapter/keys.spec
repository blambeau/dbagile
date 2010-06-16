require File.expand_path('../../../spec_helper', __FILE__)
describe "::DbAgile::Adapter#keys" do
  
  Fixtures::adapters_under_test.each do |adapter|
  
    describe "When called on a table without key" do
      subject{ adapter.keys(:dbagile) }
      specify{ 
        subject.should == []
      }
    end
  
    describe "When called on a table with a single key" do
      before{ 
        adapter.create_table(nil, :example_1, {:id => Integer}) 
        adapter.key!(nil, :example_1, [:id])
      }
      subject{ 
        adapter.keys(:example_1) 
      }
      specify{ 
        subject.should == [[:id]]
      }
    end
  
    describe "When called on a table with multiple keys" do
      before{ 
        adapter.create_table(nil, :example_2, {:id => Integer, :name => String, :version => String}) 
        adapter.key!(nil, :example_2, [:id])
        adapter.key!(nil, :example_2, [:name, :version])        
      }
      subject{ 
        adapter.keys(:example_2) 
      }
      specify{ 
        subject.should == [[:id], [:name, :version]]
      }
    end
  
  end
  
end