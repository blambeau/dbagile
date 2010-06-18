require File.expand_path('../../../../spec_helper', __FILE__)
describe "::DbAgile::SequelAdapter.transaction" do
  
  let(:adapter){ Fixtures::sqlite_testdb_sequel_adapter }
  
  describe "When with SQL" do
    specify{ 
      begin
        adapter.transaction do |t|
          t.insert(t, :dbagile, :id => 1)
          t.dataset(:dbagile).to_a.should == [{:id => 1, :version => nil, :schema => nil}]
          raise StandardError
        end
      rescue => ex
        adapter.dataset(:dbagile).to_a.should == []
      end
    }
  end

end