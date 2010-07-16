require File.expand_path('../../../spec_helper', __FILE__)
describe "::DbAgile::Adapter.dataset" do
  
  Fixtures::adapters_under_test.each do |adapter|
  
    describe "When called on non existing table" do
      subject{ lambda{ adapter.dataset(:no_such_table) } }
      specify {
        subject.should raise_error 
      }
    end
  
    describe "When called on an existing table" do
      subject{ adapter.dataset(:dbagile) }
      specify {
        subject.should be_kind_of(Enumerable) 
        subject.should be_kind_of(::DbAgile::Contract::Dataset)
        subject.should respond_to(:to_a)
      }
    end
    
    describe "When called on a given table, with records" do
      before{ 
        adapter.create_table(nil, :example, :id => Integer) 
        adapter.insert(nil, :example, :id => 1)
      }
      specify{
        adapter.dataset(:example).to_a.should == [{:id => 1}]
      }
    end

    describe "When called with a pojection tuple" do
      before{ 
        adapter.create_table(nil, :example2, :id => Integer) 
        adapter.insert(nil, :example2, :id => 1)
      }
      specify{
        adapter.dataset(:example2, {:id => 1}).to_a.should == [{:id => 1}]
        adapter.dataset(:example2, {:id => 2}).to_a.should be_empty
      }
    end
  
  end
  
end