require File.expand_path('../../../spec_helper', __FILE__)
describe "DbAgile::Database::insert" do
  
  let(:adapter){ DbAgile::MemoryAdapter.new }
  let(:database){ DbAgile::connect(adapter) }
  before{
    database.unshift_main_delegate(::DbAgile::Plugin::AgileTable)
    database.unshift_table_delegate(:example, ::DbAgile::Plugin::Defaults, :now => "now")
  }
  
  specify("Inserting in example leads to a now") do
    database.insert(:example, {:id => 1}).should == {:id => 1, :now => "now"}
  end

  specify("Inserting in no_example does not lead to a now") do
    database.insert(:no_example, {:id => 1}).should == {:id => 1}
  end

end