require File.expand_path('../../../../../spec_helper', __FILE__)
describe "::DbAgile::MemoryAdapter::Table.check_key" do
  
  let(:heading){ {:id => Integer, :version => String, :name => String} }
  let(:tuples){ [
    {:id => 1, :version => DbAgile::VERSION, :name => "dbagile"},
    {:id => 2, :version => "3.8.0", :name => "sequel"},
  ] }
  let(:table){ DbAgile::MemoryAdapter::Table.new(heading, tuples) }
  
  context "when called with a single key and violating tuple" do
    let(:key){ table.add_key([:id]) }
    subject{ table.check_key({:id => 1}, key) }
    it{ should be_false }
  end
  
  context "when called with a single key and non violating tuple" do
    let(:key){ table.add_key([:id]) }
    subject{ table.check_key({:id => 5}, key) }
    it{ should be_true }
  end
  
  context "when called with a composite key and non violating tuple" do
    let(:key){ table.add_key([:id, :name]) }
    subject{ table.check_key({:id => 1, :name => "hello"}, key) }
    it{ should be_true }
  end
  
  context "when called with a composite key and violating tuple" do
    let(:key){ table.add_key([:id, :name]) }
    subject{ table.check_key({:id => 1, :name => "dbagile"}, key) }
    it{ should be_false }
  end
  
end
  
