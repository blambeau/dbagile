require File.expand_path('../../fixtures', __FILE__)
describe "::DbAgile::Adapter.create_table" do
  
  Fixtures::adapters_under_test.each do |adapter|
  
    describe "When called on an existing table" do
      subject{ lambda{ adapter.create_table(nil, :dbagile, {:id => Integer}) } }
      it{ should raise_error }
    end

    describe "When called on an unexisting table" do
      subject{ adapter.create_table(nil, :example, {:id => Integer, :name => String}) }
      specify{ 
        subject.should be_true
        adapter.has_table?(:example).should be_true
        adapter.column_names(:example, true).should == [:id, :name]
      }
    end

  end
  
end