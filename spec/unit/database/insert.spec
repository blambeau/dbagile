require File.expand_path('../../../spec_helper', __FILE__)
describe "DbAgile::Database::insert" do
  
  let(:adapter){ DbAgile::MemoryAdapter.new }
  let(:database){ DbAgile::connect(adapter) }
  before{
    database.plug(::DbAgile::Plugin::AgileTable)
    database.table_plug(:example, ::DbAgile::Plugin::Defaults, :now => "now")
  }
  
  specify("Inserting in example leads to a now") do
    database.transaction do |t|
      t.insert(:example, {:id => 1}).should == {:id => 1, :now => "now"}
    end
  end

  specify("Inserting in no_example does not lead to a now") do
    database.transaction do |t|
      t.insert(:no_example, {:id => 1}).should == {:id => 1}
    end
  end

end